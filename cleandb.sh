#Copyright 2021 EPOS ERIC
# 
# Licensed under the Apache License, Version 2.0 (the "License"); you may not
# use this file except in compliance with the License.  You may obtain a copy
# of the License at
# 
#   http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
# License for the specific language governing permissions and limitations under
# the License.

INITCERIF=docker-entrypoint-initdb.d
COUNT_DB=0
COUNT=0

mkdir $INITCERIF

# METADATA CATALOGUE

for x in build-and-clean/clean/*; do
cp  $x $INITCERIF/$((COUNT_DB))_$((COUNT))_${x##*/}
done 
COUNT=$((COUNT + 1))

COUNT=0
COUNT_DB=$((COUNT_DB + 1))

for x in build-and-clean/build/*; do
cp  $x $INITCERIF/$((COUNT_DB))_$((COUNT))_${x##*/}
done 
COUNT=$((COUNT + 1))

COUNT=0
COUNT_DB=$((COUNT_DB + 1))

for x in metadata-catalogue/build/*; do
echo "\connect cerif;" > $INITCERIF/$((COUNT_DB))_$((COUNT))_${x##*/}
cp  $x $INITCERIF/$((COUNT_DB))_$((COUNT))_${x##*/}
done
COUNT=$((COUNT + 1))

for x in metadata-catalogue/epos-datamodel-db/*; do
echo "\connect cerif;" > $INITCERIF/$((COUNT_DB))_$((COUNT))_${x##*/}
cat  $x >> $INITCERIF/$((COUNT_DB))_$((COUNT))_${x##*/}
done
COUNT=$((COUNT + 1))

COUNT=0
COUNT_DB=$((COUNT_DB + 1))

# USER GROUP CATALOGUE

for x in users-group-catalogue/build/*; do
echo "\connect cerif;" > $INITCERIF/$((COUNT_DB))_$((COUNT))_${x##*/}
cp  $x $INITCERIF/$((COUNT_DB))_$((COUNT))_${x##*/}
done
COUNT=$((COUNT + 1))

for x in users-group-catalogue/epos-usergroup-db/*; do
echo "\connect cerif;" > $INITCERIF/$((COUNT_DB))_$((COUNT))_${x##*/}
cat  $x >> $INITCERIF/$((COUNT_DB))_$((COUNT))_${x##*/}
done
COUNT=$((COUNT + 1))

COUNT=0
COUNT_DB=$((COUNT_DB + 1))

# SHARING CATALOGUE
for x in sharing-catalogue/build/*; do
cp  $x $INITCERIF/$((COUNT_DB))_$((COUNT))_${x##*/}
done 
COUNT=$((COUNT + 1))

for x in sharing-catalogue/epos-sharing-db/*; do
echo "\connect cerif;" > $INITCERIF/$((COUNT_DB))_$((COUNT))_${x##*/}
cat  $x >> $INITCERIF/$((COUNT_DB))_$((COUNT))_${x##*/}
done
COUNT=$((COUNT + 1))

COUNT=0
COUNT_DB=$((COUNT_DB + 1))

# CONVERTER CATALOGUE
for x in converter-catalogue/build/*; do
cp  $x $INITCERIF/$((COUNT_DB))_$((COUNT))_${x##*/}
done 
COUNT=$((COUNT + 1))

for x in converter-catalogue/epos-converter-db/*; do
echo "\connect cerif;" > $INITCERIF/$((COUNT_DB))_$((COUNT))_${x##*/}
cat  $x >> $INITCERIF/$((COUNT_DB))_$((COUNT))_${x##*/}
done
COUNT=$((COUNT + 1))

COUNT=0
COUNT_DB=$((COUNT_DB + 1))

# PROCESSING CATALOGUE
for x in processing-catalogue/build/*; do
cp  $x $INITCERIF/$((COUNT_DB))_$((COUNT))_${x##*/}
done 
COUNT=$((COUNT + 1))

for x in processing-catalogue/epos-processing-db/*; do
echo "\connect cerif;" > $INITCERIF/$((COUNT_DB))_$((COUNT))_${x##*/}
cat  $x >> $INITCERIF/$((COUNT_DB))_$((COUNT))_${x##*/}
done
COUNT=$((COUNT + 1))

COUNT=0
COUNT_DB=$((COUNT_DB + 1))

# POSTGIS SETTINGS
for x in build-and-clean/postgis-setting/*; do
echo "\connect cerif;" > $INITCERIF/$((COUNT_DB))_$((COUNT))_${x##*/}
cat  $x >> $INITCERIF/$((COUNT_DB))_$((COUNT))_${x##*/}
done
COUNT=$((COUNT + 1))