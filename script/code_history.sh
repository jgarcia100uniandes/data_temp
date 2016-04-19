#!/bin/bash 
rm back.csv
rm front.csv
IFS=$'\n' 
cd HomeServices-Front
for rev in $(git log --pretty="%h;%ae;%ad;%s"); do 
	export rev_id=$(echo $rev|awk -F ';' '{print $1}')
	export user=$(echo $rev|awk -F ';' '{print $2}')
	export rev_date=$(echo $rev|awk  -F ';' '{print($3)}')	
	export message=$(echo $rev|awk  -F ';' '{print $4 $5}')
	#change rev
	git checkout $rev_id
	export loc=$(cloc app|grep SUM|awk '{print $5}')
	export test_loc=$(cloc e2e/specs|grep SUM|awk '{print $5}')
	git reset --hard origin/master
	git checkout master
	echo $rev_id,$user,$rev_date,$loc,$test_loc,$message >> ../front.csv
done
cd ..


cd HomeService-Back
for rev in $(git log --pretty="%h;%ae;%ad;%s"); do 
	export rev_id=$(echo $rev|awk -F ';' '{print $1}')
	export user=$(echo $rev|awk -F ';' '{print $2}')
	export rev_date=$(echo $rev|awk  -F ';' '{print($3)}')	
	export message=$(echo $rev|awk  -F ';' '{print $4 $5}')
	#change rev
	git checkout $rev_id
	export logic_loc=$(cloc home-services-logic/src/main|grep Java|awk '{print $5}')
	export logic_test_loc=$(cloc home-services-logic/src/test|grep Java|awk '{print $5}')
	export api_loc=$(cloc home-services-api/src/main|grep Java|awk '{print $5}')
	export api_test_loc=$(cloc home-services-api/src/test|grep Java|awk '{print $5}')
	git reset --hard origin/master
	git checkout master
	echo $rev_id,$user,$rev_date,$logic_loc,$logic_test_loc,$api_loc,$api_test_loc,$message >> ../back.csv
done
cd ..

