#!/bin/sh

gitbuildmgcp () {
	SITE_US=us-east-1
	SITE_EU=eu-central-1
	SITE_JP=ap-northeast-1
	SITE_SG=ap-southeast-1
	SITE_AU=ap-southeast-2
	SITE_IN=ap-south-1
	SITE_UAENORTH=uaenorth
	SITE_ADDA=adda
	DEPLOYMENT_AZ_TEST="$SITE_UAENORTH"
	DEPLOYMENT_AZ_INT="$SITE_UAENORTH"
	DEPLOYMENT_AZ_STAG="$SITE_ADDA"
	DEPLOYMENT_AZ_PROD="$SITE_ADDA"
	DEPLOYMENT_AWS_TEST="$SITE_US $SITE_EU"
	DEPLOYMENT_AWS_INT="$SITE_US"
	DEPLOYMENT_AWS_STAG="$SITE_US $SITE_EU $SITE_JP $SITE_SG $SITE_AU $SITE_IN"
	DEPLOYMENT_AWS_PROD="$SITE_US $SITE_EU $SITE_JP $SITE_SG $SITE_AU $SITE_IN"
	ENV=
	RESOURCE=
	ACTION=
	PROVIDER=
	GLOBAL=
	CHECK_VAR=true
	check_variable () {
		while [ $# -gt 1 ]
		do
			key="$1"
			case $key in
				(-e | -env | --env) ENV="${2}"
					shift ;;
				(-r | -resource | --resource) RESOURCE="${2}"
					shift ;;
				(-a | -action | --action) ACTION="${2}"
					shift ;;
				(-p | -provider | --provider) PROVIDER="${2}"
					shift ;;
				(-g | -global | --global) GLOBAL="${2}"
					shift ;;
				(*)  ;;
			esac
			shift
		done
		if [ -z "$ENV" ]
		then
			echo "env not specified"
			CHECK_VAR=false
			return
		fi
		if [ -z "$RESOURCE" ]
		then
			echo "resource not specified"
			CHECK_VAR=false
			return
		fi
		if [ -z "$ACTION" ]
		then
			echo "action not specified"
			CHECK_VAR=false
			return
		fi
		if [ -z "$PROVIDER" ]
		then
			echo "provider not specified"
			CHECK_VAR=false
			return
		fi
		echo "$ACTION $RESOURCE resources to $PROVIDER $ENV environment" | awk '{print toupper(substr($0,0,1))tolower(substr($0,2))}'
	}
	check_credential () {
		echo ""
		echo "===== Credential checking ====="
		AD_APP_NAME="ops-ops-adapp-ops-deployment"
		expiration_date=$(az ad app list --display-name $AD_APP_NAME --query "[].{endDate:passwordCredentials[0].endDate}"  --out tsv)
		if [ $? -eq 0 ]
		then
			expiration=$(date -d $expiration_date +%s)
			warnning_date=$(date -d "+14 days" +%s)
			if [ $expiration -le $warnning_date ]
			then
				echo ""
				echo "===================== WARNING ================================="
				echo "Please renew the following AD app credentials:"
				echo "ops-ops-adapp-ops-deployment & mgcp-ops-adapp-mgcp-deployment"
				echo ""
				echo "The expiration date is on $(date -d $expiration_date)"
				echo ""
				echo "Ref: https://wiki.jarvis.trendmicro.com/display/TEPM/How+to+renew+Azure+AD+app+credential+for+CICD"
				echo "===================== WARNING ================================="
				echo ""
			else
				echo "Credential expiration: $expiration_date"
			fi
		else
			echo "Can not retrieve $AD_APP_NAME passwordCredentials"
			return
		fi
	}
	deploy_az () {
		case $ENV in
			(test) deploy_az_resource "$DEPLOYMENT_AZ_TEST" ;;
			(int) deploy_az_resource "$DEPLOYMENT_AZ_INT" ;;
			(stag) deploy_az_resource "$DEPLOYMENT_AZ_STAG" ;;
			(prod) deploy_az_resource "$DEPLOYMENT_AZ_PROD" ;;
			(*)  ;;
		esac
	}
	deploy_aws () {
		case $ENV in
			(test) deploy_aws_resource "$DEPLOYMENT_AWS_TEST" ;;
			(int) deploy_aws_resource "$DEPLOYMENT_AWS_INT" ;;
			(stag) deploy_aws_resource "$DEPLOYMENT_AWS_STAG" ;;
			(prod) deploy_aws_resource "$DEPLOYMENT_AWS_STAG" ;;
			(*)  ;;
		esac
	}
	deploy_az_resource () {
		case $GLOBAL in
			(true | TRUE | t) case $ENV in
					(prod) deploy_branch "deploy/prod/global-adda/common/$RESOURCE/$ACTION" ;;
					(*) deploy_branch "deploy/$ENV/global/common/$RESOURCE/$ACTION" ;;
				esac ;;
			(*) sitearray=(`echo $1 | tr ' ' ' '`)
				for site in "${sitearray[@]}"
				do
					deploy_branch "deploy/$ENV/$site/common/$RESOURCE/$ACTION"
				done ;;
		esac
		if [[ "${ACTION}" == "plan" ]]
		then
			check_credential
		fi
	}
	deploy_aws_resource () {
		case $GLOBAL in
			(true | TRUE | t) deploy_branch "deploy/$ENV/global/common/$RESOURCE/$ACTION" ;;
			(*) sitearray=(`echo $1 | tr ' ' ' '`)
				for site in "${sitearray[@]}"
				do
					deploy_branch "deploy/$ENV/$site/common/$RESOURCE/$ACTION"
				done ;;
		esac
	}
	deploy_branch () {
		BRANCH=$1
		# echo "git push origin ${BRANCH}"
		# git branch -D $BRANCH
		# git push origin --delete $BRANCH
		# git branch $BRANCH
		# git push origin $BRANCH
        echo "======================================================"
        echo $BRANCH
        echo "======================================================"
        
	}
	check_variable $@
	if [[ ${CHECK_VAR} == true ]]
	then
		case $PROVIDER in
			(az | AZ | azure) deploy_az ;;
			(aws | AWS) deploy_aws ;;
			(*)  ;;
		esac
	fi
	return 1
}

echo "gitbuildmgcp -env prod -resource all -action plan -provider az -global true"
gitbuildmgcp -env prod -resource all -action plan -provider az -global true
echo "gitbuildmgcp -env prod -resource all -action apply -provider az -global true"
gitbuildmgcp -env prod -resource all -action apply -provider az -global true
echo "gitbuildmgcp -env prod -resource all -action plan -provider az"
gitbuildmgcp -env prod -resource all -action plan -provider az
echo "gitbuildmgcp -env prod -resource all -action apply -provider az"
gitbuildmgcp -env prod -resource all -action apply -provider az

echo "gitbuildmgcp -env stag -resource all -action plan -provider aws -global true"
gitbuildmgcp -env stag -resource all -action plan -provider aws -global true
echo "gitbuildmgcp -env stag -resource all -action apply -provider aws -global true"
gitbuildmgcp -env stag -resource all -action apply -provider aws -global true
echo "gitbuildmgcp -env stag -resource all -action plan -provider aws"
gitbuildmgcp -env stag -resource all -action plan -provider aws
echo "gitbuildmgcp -env stag -resource all -action apply -provider aws"
gitbuildmgcp -env stag -resource all -action apply -provider aws

echo "gitbuildmgcp -env prod -resource all -action plan -provider aws -global true"
gitbuildmgcp -env prod -resource all -action plan -provider aws -global true
echo "gitbuildmgcp -env prod -resource all -action apply -provider aws -global true"
gitbuildmgcp -env prod -resource all -action apply -provider aws -global true
echo "gitbuildmgcp -env prod -resource all -action plan -provider aws"
gitbuildmgcp -env prod -resource all -action plan -provider aws
echo "gitbuildmgcp -env prod -resource all -action apply -provider aws"
gitbuildmgcp -env prod -resource all -action apply -provider aws