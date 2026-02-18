BEGIN;

-- Function to sync admin users to all groups
-- This function adds all users with isadmin='true' to all existing groups
-- with role='ADMIN' and request_status='ACCEPTED'
-- It skips users who are already members of a group (no duplicates)

CREATE OR REPLACE FUNCTION usergroup_catalogue.sync_admin_users_to_all_groups()
RETURNS void AS $$
BEGIN
    INSERT INTO usergroup_catalogue.metadata_group_user (id, auth_identifier, group_id, request_status, role)
    SELECT 
        uuid_generate_v4()::varchar(100),
        u.auth_identifier,
        g.id,
        'ACCEPTED',
        'ADMIN'
    FROM usergroup_catalogue.metadata_user u
    CROSS JOIN usergroup_catalogue.metadata_group g
    WHERE u.isadmin = 'true'
      AND NOT EXISTS (
          SELECT 1 
          FROM usergroup_catalogue.metadata_group_user gu 
          WHERE gu.auth_identifier = u.auth_identifier 
            AND gu.group_id = g.id
      );
END;
$$ LANGUAGE plpgsql;

-- Schedule the job to run every hour (at minute 0)
-- Job name: sync_admin_users_to_groups
-- Schedule: '0 * * * *' means at minute 0 of every hour
SELECT cron.schedule(
    'sync_admin_users_to_groups',
    '0 * * * *',
    $$SELECT usergroup_catalogue.sync_admin_users_to_all_groups();$$
);

-- Update the job to run in the cerif database
UPDATE cron.job SET database = 'cerif' WHERE jobname = 'sync_admin_users_to_groups';

-- Run the sync immediately on database initialization
SELECT usergroup_catalogue.sync_admin_users_to_all_groups();

END;
