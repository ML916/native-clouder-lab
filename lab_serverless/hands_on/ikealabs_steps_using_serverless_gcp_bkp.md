#TODO
update what you will learn and understand sessions
add reference links to the hands-on

# What you will learn

In this hands_on, you will learn how-to:

- Use gcloud cmd and console to interact with your GCP Project
- Convert a nodejs app to a container and push that to GCR 
- Deploy and test a Cloud Run Service (without security, unauthenticated call) using the container image you created (not good, because it's public available without any proctection like LB, Api gateway or auth)
- Learn a proper way to store a Secret using Secret Manager
- Understand Apispec
- Deploy API Gateway to project and test.
- Define API Gateway IAM and Roles on GCP (less permissive and security from beginning)
- Deploy new cloud run with security this time, attach SA, test, should not be accesible publicly.
- Update apispec and deploy API gateway to call secured cloud run back end.
- Test if App is working properly behind the API Gateway securely.
- As next step we will use Cloud Firestore and Pubsub to have more real product, where data beeningested via pubsub to firestore and your app get data corresponds to your input from firestore.
- Clean up everything

# Understanding what you will do 

ADD draw.io

ADD link and explain the node.js application

Describe the archtecture

Describe GCP Serverless Products







*References for further reading:*

* [serverless computing](https://en.wikipedia.org/wiki/Serverless_computing)  

* [Cloud Run documentation](https://cloud.google.com/run) 

* [Secret Manager overview](https://cloud.google.com/secret-manager/docs/overview#secret_manager)

# Requirements

The following requirements must be done before starting the hands_on:

* 1 - Install gcloud SDK
* 2 - Install Docker
* 3 - Install nodejs
* 4 - Must have Github CLoud access and in ingka-group-digital org, if you dont have reach out to engineering-services-support slack channel or https://ingka.slack.com/archives/CP9M1MRL1/p1625499704428500
* 5 - Must have GCP acccess, if not reach out cloud_support slack channel

# Steps for deploying the IKEAlabs application on GCP  
  
---  
  
## [clone the lab repository]  

* 1 - Open a Terminal or favourite development tool and clone this repo

```
git clone git@github.com:ingka-group-digital/native-clouders-ikealabs.git
```

* 2 - cd into the hands_on directory

```
cd labs/lab_serverless/hands_on
```

## [run the app locally]  

* 1 - Run the node.js application locally 

```
cd app
npm install
node index.js
```

* 2 - curl localhost and list the IKEA Products using the app key

```
curl localhost:8080/
```

(Example Output)  

![api_output](./media/lab_api_output.png)


## [containerize the application using docker]

*Replace <YOUR_NAME> tag for your actual surname when required"*  


* 1 - create the app Dockerfile

```
# Stage 1
FROM node:16-alpine3.14 as builder

WORKDIR /home/node
ADD . .

RUN yarn install

# Stage 2
FROM node:16-alpine3.14

WORKDIR /home/node
COPY --chown=node:node --from=builder /home/node .

USER node

ENV HOST 0.0.0.0

EXPOSE 8080

CMD ["yarn", "start"]
```

* 2 - build the app container image
```
docker build -t eu.gcr.io/ingka-native-ikealabs-dev/app-<YOUR_NAME>:1.0.0 .
```

* 3 - run the container image locally
```
docker run -p8080:8080 eu.gcr.io/ingka-native-ikealabs-dev/app-<YOUR_NAME>:1.0.0
```

* 4 - access the app container 
```
curl http://localhost:8080/
```

* 5 - stop the running using the container ID visible with "docker ps"
```
docker ps
docker stop "CONTAINER ID"
```

*References for further reading:*  

* [docker develop doc](https://docs.docker.com/develop/)
* [dockerfile multistage build](https://docs.docker.com/develop/develop-images/multistage-build/)


## [Use gcloud cmd and console to interact with your GCP Project]

* 1 - connect to GCP ikealabs Project

```
gcloud config set project ingka-native-ikealabs-dev
```

* 2 - confirm gcloud is using right Project

```
gcloud config list project
```

(Example Output)  

![gcloud_output](./media/lab_gcloud_output.png)


*References for further reading:*  

* [gcloud_config_set](https://cloud.google.com/sdk/gcloud/reference/config/set)  


## [create app key on SECRET MANAGER]

***IT'S A BIG MISTAKE TO PUSH SENSITIVE INFORMATION TO GIT***

*Pushing sensitive information to GIT it's still a very common mistake made by IKEA Engineers. Instead, it's better to use a proper secret management tool, as GCP Secret Manager, to ensure your sensitive information is safely stored.*

* 1 - Create the App Secret on GCP Secret Manager

*Replace <YOUR_NAME> tag for your actual surname when required"*  

```
gcloud secrets create API_KEY_SERVERLESSLAB-<YOUR_NAME> \
    --replication-policy="automatic"
```

* 2 - Add version (value) to the Secret key

```
echo -n "put your secret key value" | \
    gcloud secrets versions add API_KEY_SERVERLESSLAB-<YOUR_NAME> --data-file=-
```

- NOTE : 

Its a better way that we always think about security, the idea of secret manager is to hide the secret key from our eyes. \
So, rather passing your secret value directly in the command, you can put this in a flat file and use that file , like this : \
```
gcloud secrets versions add API_KEY_SERVERLESSLAB-<YOUR_NAME> --data-file="/path/to/file.txt"
```

You can combine both steps in one go also : 
```
gcloud secrets create API_KEY_SERVERLESSLAB-<YOUR_NAME> --data-file="/path/to/file.txt"
```

*Delete the file and of course dont push that one to GIT! :)*

* 3 - list the secrets on secret manager and find yours

```
gcloud secrets list
```

## [create a cloud run service using the app container]

* 1 - push the nodejs app container to GCR
```
docker push eu.gcr.io/ingka-native-ikealabs-dev/app-<YOUR_NAME>:1.0.0
```

* 2 - deploy first Cloud Run service using the container
```
gcloud run deploy serverless-lab-<YOUR_NAME> --region europe-west1 --image eu.gcr.io/ingka-native-ikealabs-dev/app-<YOUR_NAME>:1.0.0 --project ingka-native-ikealabs-dev --platform "managed" --memory 512Mi --cpu 1 --allow-unauthenticated --update-secrets=API_KEY=API_KEY_SERVERLESSLAB-<YOUR_NAME>:latest --quiet
```

* 3 - Go to GCP Console and check if the Service URL is available


*References for further reading:*  

* [gcloud command for cloud run deployment](https://cloud.google.com/sdk/gcloud/reference/run/deploy)


## [deploy the GCP API Gateway]

It's important to protect your API and to avoid that to be directly exposed to the Internet. There are different GCP Services which can be used for that, like [Google Load Balancing](https://cloud.google.com/load-balancing/docs) and [API Gateway](https://cloud.google.com/api-gateway).

The GCP API Gateway is a fully managed serverless gateway which provides protection for our Cloud Run API. The API Gateway offers services around Security, Authentication and Observability without a high maintainability requirement.

The API Gateway uses [OpenAPI (swagger)](https://swagger.io/specification/) specification.

* 1 - Create API apispec.yaml for the API Gateway

 *Replace <APP_URL_CLOUD_RUN> tag for your actual surname when required"*  

```
# apispec.yaml
swagger: '2.0'
info:
  title: serverless_lab cloud run as backend
  description: Cloud API gateway for node app on cloud run
  version: 1.0.0
schemes:
- https
produces:
- application/json
x-google-backend:
  address: <APP_URL_CLOUD_RUN>
paths:
  /assets/{asset}:
    get:
      parameters:
        - in: path
          name: asset
          type: string
          required: true
          description: Name of the asset.
      summary: Assets
      operationId: getAsset
      responses:
        '200':
          description: A successful response
          schema:
            type: string
  /:
    get:
      summary: welcome to IKEA Labs!
      operationId: welcome
      responses:
        '200':
          description: A successful response
          schema:
            type: string
  /api/products:
    get:
      summary: api call
      operationId: api_call
      responses:
        '200':
          description: A successful response
          schema:
            type: string
            
```

*References for further reading:*  

* [swagger specification] https://swagger.io/specification/v2/


## [Deploy API Gateway]

* 1 - Create the api config

```
gcloud api-gateway api-configs create serverlesslab-apispec-config-<YOUR_NAME> \
  --api=serverlesslab-apigateway-<YOUR_NAME> --openapi-spec=apispec.yaml \
  --project=ingka-native-ikealabs-dev
```

* 2 - Deploy Gateway with API config

```
gcloud api-gateway gateways create serverlesslab-apigateway-<YOUR_NAME> \
  --api=serverlesslab-apigateway-<YOUR_NAME> --api-config=serverlesslab-apispec-config-<YOUR_NAME> \
  --location=europe-west1 --project=ingka-native-ikealabs-dev
```

* [gcloud for api gateway for cloud run as backend] https://cloud.google.com/api-gateway/docs/get-started-cloud-run

- TEST with Gateway

Navigate to "API Gateway" , choose your deployed gateway, goto "GATEWAYS" tab, click on the "Gateway url" , this will give yur the same response when you hit the direct cloud run or running your app in localhost:8080

## take a Pause, lets summerize and think about what we have learnt so far:

* 1 - we have dockerize our nodejs app
* 2 - push to GCR and deployed on a cloud run.
* 3 - created apispec.yaml
* 4 - Deployed a API gateway with that apispec
* 5 - tested the gateway by get same response even hitting the gateway URL

Right now, the app is running on serverless engine (cloud run) as backend of a gateway which is also serverless. This simple environment also means a low maintainability costs.


# [let's retake the last steps with a more secure approach this time]

Right now the Cloud Run app is public, anyone can call from internet even if behind the API Gateway!!

Let's start by creating a proper Service Account for our Cloud Run Instance.

## [create a Service account and assign role]

* 1 - Create Cloud Run Service account

```
gcloud iam service-accounts create serverless-lab-cr-invoker-<YOUR_NAME> \
    --description="SA to be used to autheticate cloud run back end" \
    --display-name="serverless-lab-cr-invoker-<YOUR_NAME>"
```

* 2 - Grant IAM Role to Service Account

```
gcloud projects add-iam-policy-binding ingka-native-ikealabs-dev \
    --member="serviceAccount:serverless-lab-cr-invoker-<YOUR_NAME>@ingka-native-ikealabs-dev.iam.gserviceaccount.com" \
    --role="roles/run.invoker"
```
**NOTE : The Service Account should be as less permissive as possible for that to work. Avoid using bigger roles like "owner" or "editor" on your GCP Projects.
Your objective will always have to be reduce as much as possible the permission on SA, so fine grain it really. 
GCP has one great role for this job, "cloud run invoker", we are using it.
Its recommend to create custom roles, if you need to 'cherry pick' only required permissions.**


## [Deploy Cloud Run again using SA and no allow auth]

* 1 - Deploy Cloud run using the same container image

```
gcloud run deploy serverless-lab-secured-<YOUR_NAME> --region europe-west1 --image eu.gcr.io/ingka-native-ikealabs-dev/app-<YOUR_NAME>:1.0.0 --project ingka-native-ikealabs-dev --platform "managed" --memory 512Mi --cpu 1 --no-allow-unauthenticated --service-account serverless-lab-cr-invoker-<YOUR_NAME>@ingka-native-ikealabs-dev.iam.gserviceaccount.com --max-instances=2 --update-secrets=API_KEY=API_KEY_SERVERLESSLAB-<YOUR_NAME>:latest --quiet
```

**NOTE : we have added a service account and used "no-allow-unauthenticated". 
Also we have put "max-instances", it's a good practice to limit the upper scale in serverless engines, in case something gets wrong.**

* 2 - try to access your app URL on Cloud Run

Try the cloud run URL in browser, this time you would get "access forbidden", it wont show you the api. Meaning, it's public protected.


## [Update the apispec.yaml to have your new APP cloud run URL]

* 1 - edit apispec.yaml and update the APP_URL

```
x-google-backend:
  address: <APP_URL_CLOUD_RUN>
```

## [deploy the API Gateway with new config to call secured cloud run]

* 1 - create new apispec.yaml with updated cloud run url

```
gcloud api-gateway api-configs create serverlesslab-apispec-config-secured-<YOUR_NAME> \
  --api=serverlesslab-apigateway-secured-<YOUR_NAME> --openapi-spec=apispec.yaml \
  --project=ingka-native-ikealabs-dev --backend-auth-service-account=serverless-lab-cr-invoker-<YOUR_NAME>@ingka-native-ikealabs-dev.iam.gserviceaccount.com
```

* 2 - deploy Gateway with API config, to call secured cloud run backend

```
gcloud api-gateway gateways create serverlesslab-apigateway-secured-<YOUR_NAME> \
  --api=serverlesslab-apigateway-secured-<YOUR_NAME> --api-config=serverlesslab-apispec-config-secured-<YOUR_NAME> \
  --location=europe-west1 --project=ingka-native-ikealabs-dev
```

- TEST
Navigate to "API Gateway" , choose your deployed gateway, goto "GATEWAYS" tab, click on the "Gateway url" , this will give yur the same response when you hit the direct cloud run or running your app in localhost:8080, so even the cloud run back end is secured, you are able to see response when you hit the gateway. The reason behind this is we have created the gateway with the same SA with which the cloud run had been deployed, so gateway is getting the privilage to call the secured cloud run using the SA, and dont forget SA has exacly "cloud run invoker" role.

* NOTE : From latency perspective, it better to deploy your cloud run and gateway in same region.

# [it's all DONE]

The App is now running on GCP and it's available for everyone to access that behind the API Gateway. During this lab, we did use several GCP Serverless products in a way to demonstrate the simplicity and easy maintainability 


## [BONUS: add Auth on API Gateway]: 

Secured, right ? Hmmm, let us think, are we missing something more? 

Ohh... The gateway itself is not secured, means anyone can publiclly access the gateway URL, by this they can reach our secured back end.

Google Api Gateway does support quite a few security mechanism to handle this , for example Auth0 . This can be treated as next level, not bringing in this lab scope.

However following documets will really be handy =>

a. https://cloud.google.com/api-gateway/docs/authentication-method \
b. https://cloud.google.com/api-gateway/docs/authenticating-users-auth0 \
c. https://cloud.google.com/api-gateway/docs/authenticate-service-account \
d. https://cloud.google.com/api-gateway/docs/api-access-overview 


# [Lets play around with more serverless products]

Now the basic node.js app that we had deployed on cloud run is finding the product details from a static json file.
In real world, an api (mocro service )will fetch data from a DB . And then obviusly we need to have a data ingestion layer which populates the data base.

One best architecture says that product should be decoupled from its nehibour, that gives much flexibility and good resiliency too.
Event driven approach is one approach that suffice this need.

So , your data producer (often a separate team) produces data in some topic and you have the mandate to grab those data s event and ingest in your DB, your front end 
api will querry this DB based on some input to sho the data.

### GCP's offerings (serverless !)
1 - Cloud PubSub as HA topic, which can handels millions of messages with gurantee of atleast once delivery, highly scalable and fully managed.

2 - CLoud Firestore, higly scalablae no-sql document data base.

Both are much cost effective. There are other DB offerings from GCP too for example CLoud SQL (Postgres), Cloud BigQuerry or CLoud Bigtable, even Cloud Memorystore Redis as cache,
but we are using CLoud Firestore for our lab.

Firestore is created based on Fairebase opensource DB. It has two flavor, native mode(more read comapre to writes) and Data store mode(more write comapere to reads).
Since its serverless, you just have to enable its api, thats it, start using it. Google provided out of the box lib to access it in many languages.
It can scale automatically when connections increases, optimize itself automatically for faster result and repilcates data too to rprevent data loss, all automatically.

Same as pubsub, you just need to enable api and create own topic, voila , start using it.

So, in this section of our lab, we will be using one more cloud run as new service that will fetch data from Pub/Sub and store into firestore.
we will re-write our first app that will read data from firestore, so the api will dynamically will accept some product name and will fetch is available quanltity from firestore and show as reesponse. 

### lets Begin ! 
(we will skip security and api gateway part here for the time constarint but pls take note security is really a a mandetory element)

1 - Firestore api is already enabled for this lab and its in native mode. \
Firebase console : https://console.firebase.google.com/project/ingka-native-ikealabs-dev/firestore/data/~2F

2 - Create docker image and push in GCR  --> goto "app_firestore" folder 
```
docker build -t eu.gcr.io/ingka-native-ikealabs-dev/app-firestore-<YOUR_NAME>:1.0.0 .
docker push eu.gcr.io/ingka-native-ikealabs-dev/app-firestore-<YOUR_NAME>:1.0.0
```

3 - Deploy re-written cloud run app from folder "app_firestore". Its the previous app, just reading data from firestore. \

```
gcloud run deploy app-firestore-<YOUR_NAME> --region europe-west1 --image eu.gcr.io/ingka-native-ikealabs-dev/app-firestore-<YOUR_NAME>:1.0.0 --project ingka-native-ikealabs-dev --platform "managed" --memory 512Mi --cpu 1 --allow-unauthenticated --max-instances=2 --update-secrets=API_KEY=API_KEY_SERVERLESSLAB-<YOUR_NAME>:latest --quiet
```

4 - TEST your app. \
a) using postman or Curl , (cloud_run_url)/product/availability , POST method and json payload like \
{
  "product_name" : "glimma"
} \
b) The expected result would be that no product found, since forestore is not being populated with this data. \
c) Goto firstore and add one document with product_name and product_availability, type string. Add your desided value. \
d) Retest the api now with product_name that you have just created, it should retun you available quantity. \

5 - Create docker image and push in GCR for data ingestion cloud run  --> goto "data_ingestion_from_pubsub_to_firestore" folder 
```
docker build -t eu.gcr.io/ingka-native-ikealabs-dev/pubsub_to_firestore-<YOUR_NAME>:1.0.0 .
docker push eu.gcr.io/ingka-native-ikealabs-dev/pubsub_to_firestore-<YOUR_NAME>:1.0.0
```

6 - Deploy this app on cloud run. \
```
gcloud run deploy pubsub_to_firestore-<YOUR_NAME> --region europe-west1 --image eu.gcr.io/ingka-native-ikealabs-dev/pubsub_to_firestore-<YOUR_NAME>:1.0.0 --project ingka-native-ikealabs-dev --platform "managed" --memory 512Mi --cpu 1 --allow-unauthenticated --max-instances=2 --update-secrets=API_KEY=API_KEY_SERVERLESSLAB-<YOUR_NAME>:latest --quiet
```
This app is newly build, it will be having a push based subscription on Pubsub , will accept events in json format and push it firestore collection, the jsson format will be \
```
{
  "product_name" : "SOME VALUE",
  "product_availability" : "SOME VALUE"
}
```
7 - Create the push endpoint for the cloud run --> (cloud_run_url)/product/ingestion/firestore.

8 - Create PubSub 
```
gcloud pubsub topics create product_ingestion_<YOUR ID>
```

9 - Adding cloud run Push URL to create a push based subscription.
Though it has gcloud , may be  we can use cloud console too. \
https://cloud.google.com/pubsub/docs/admin#creating_subscriptions

10 - publish one mesaage in pubsub topic 
```
gcloud pubsub topics publish product_ingestion_<YOUR ID> \
  --message=Data Push \
  [--attribute="product_name=glimma,product_availability=50"
```
Or else, we will try from Console too.

11 - Check firestore coelction, it must have your data inserted.

12 - Now try the app_forestore api that being deployed to fetch product_availability by sending product_name in request.

## [Reflections, what we have learned so far]
1 - Lets talk about each product more , particularly DB and then PubSub

2 - apart from actual error handling or UT coverage , the pubsub to firestore app needs good modificcation, you can combine functionality from app-firestore. 
That is if a product data needs to be added in firestore, app must check id product exisits or not. If exists update else create new.

3 - Events with Cloud run, GCP EventArch



# [clean everything up]

**due to cost-consciousness reason, please always remember to clean all services you just used when trying anything on a Public Cloud Provider. Nothing is free, thus it's important to keep a right mindset about avoid waste of resources.**

Remove your following GCP services on this project:

1 - cloud run services \
2 - gcp secret on secret manager \
3 - API Gateway \
4 - image on GCR \
5 - Documents (data) added in firestore collelction \
6 - Service accounts \
7 - PubSub topic and Subscriptions \


---

# Wrap up and reflection

- how can we make this solution better, more or less production ready? what we need to add next in order to make the app more reliable? (decouple, functions)
- **Never push any kind of password, api keys, access tokens to a GIT repository! Instead, use a proper Secret Management tool for storing your sensitive information.**
- Avoid expoising your API without any Protection (gateway or lb)
- Going for Serverless is a good path for simplicity and low maintainability costs
