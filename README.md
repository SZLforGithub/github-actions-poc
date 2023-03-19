# github-actions-poc

## Origin full flow
### Azure (infra-mgcp)
1. Pull latest code in your local master branch, master branch
2. stag執行

global level:
```
gitbuildmgcp -env stag -resource all -action plan -provider az -global true
gitbuildmgcp -env stag -resource all -action apply -provider az -global true
```

regional level:
```
gitbuildmgcp -env stag -resource all -action plan -provider az
gitbuildmgcp -env stag -resource all -action apply -provider az
```

3. prod 執行

global level:
```
gitbuildmgcp -env prod -resource all -action plan -provider az -global true
gitbuildmgcp -env prod -resource all -action apply -provider az -global true
```
regional level:
```
gitbuildmgcp -env prod -resource all -action plan -provider az
gitbuildmgcp -env prod -resource all -action apply -provider az
```

---

### Aws (infra)

1. Pull latest code in your local master branch, master branch
2. stag執行

global level:
```
gitbuildmgcp -env stag -resource all -action plan -provider aws -global true
gitbuildmgcp -env stag -resource all -action apply -provider aws -global true
```

regional level:
```
gitbuildmgcp -env stag -resource all -action plan -provider aws
gitbuildmgcp -env stag -resource all -action apply -provider aws
```

deploy/stag/us-east-1/all/plan  
deploy/stag/eu-central-1/all/plan  
deploy/stag/ap-northeast-1/all/plan  
deploy/stag/ap-southeast-1/all/plan  
deploy/stag/ap-southeast-2/all/plan  
deploy/stag/ap-south-1/all/plan  

3. prod 執行

global level:
```
gitbuildmgcp -env prod -resource all -action plan -provider aws -global true
gitbuildmgcp -env prod -resource all -action apply -provider aws -global true
```

regional level:
```
gitbuildmgcp -env prod -resource all -action plan -provider aws
gitbuildmgcp -env prod -resource all -action apply -provider aws
```

## Origin command flow
gitbuildmgcp -env stag -resource all -action plan -provider az -global true
- deploy/stag/global/common/all/plan

gitbuildmgcp -env stag -resource all -action apply -provider az -global true
- deploy/stag/global/common/all/apply

gitbuildmgcp -env stag -resource all -action plan -provider az
- deploy/stag/adda/common/all/plan

gitbuildmgcp -env stag -resource all -action apply -provider az
- deploy/stag/adda/common/all/apply

gitbuildmgcp -env prod -resource all -action plan -provider az -global true
- deploy/prod/global-adda/common/all/plan

gitbuildmgcp -env prod -resource all -action apply -provider az -global true
- deploy/prod/global-adda/common/all/apply

gitbuildmgcp -env prod -resource all -action plan -provider az
- deploy/prod/adda/common/all/plan

gitbuildmgcp -env prod -resource all -action apply -provider az
- deploy/prod/adda/common/all/apply

---

gitbuildmgcp -env stag -resource all -action plan -provider aws -global true
- deploy/stag/global/common/all/plan

gitbuildmgcp -env stag -resource all -action apply -provider aws -global true
- deploy/stag/global/common/all/apply

gitbuildmgcp -env stag -resource all -action plan -provider aws
- deploy/stag/us-east-1/common/all/plan
- deploy/stag/eu-central-1/common/all/plan
- deploy/stag/ap-northeast-1/common/all/plan
- deploy/stag/ap-southeast-1/common/all/plan
- deploy/stag/ap-southeast-2/common/all/plan
- deploy/stag/ap-south-1/common/all/plan

gitbuildmgcp -env stag -resource all -action apply -provider aws
- deploy/stag/us-east-1/common/all/apply
- deploy/stag/eu-central-1/common/all/apply
- deploy/stag/ap-northeast-1/common/all/apply
- deploy/stag/ap-southeast-1/common/all/apply
- deploy/stag/ap-southeast-2/common/all/apply
- deploy/stag/ap-south-1/common/all/apply

gitbuildmgcp -env prod -resource all -action plan -provider aws -global true
- deploy/prod/global/common/all/plan

gitbuildmgcp -env prod -resource all -action apply -provider aws -global true
- deploy/prod/global/common/all/apply

gitbuildmgcp -env prod -resource all -action plan -provider aws
- deploy/prod/us-east-1/common/all/plan
- deploy/prod/eu-central-1/common/all/plan
- deploy/prod/ap-northeast-1/common/all/plan
- deploy/prod/ap-southeast-1/common/all/plan
- deploy/prod/ap-southeast-2/common/all/plan
- deploy/prod/ap-south-1/common/all/plan

gitbuildmgcp -env prod -resource all -action apply -provider aws
- deploy/prod/us-east-1/common/all/apply
- deploy/prod/eu-central-1/common/all/apply
- deploy/prod/ap-northeast-1/common/all/apply
- deploy/prod/ap-southeast-1/common/all/apply
- deploy/prod/ap-southeast-2/common/all/apply
- deploy/prod/ap-south-1/common/all/apply
