# [clean everything up]

**due to cost-consciousness reason, please always remember to clean all services you just used when trying anything on a Public Cloud Provider. Nothing is free, thus it's important to keep a right mindset about avoid waste of resources.**

Remove your following GCP services on this project:

1 - cloud run services \
2 - gcp secret on secret manager \
3 - API Gateway and config\
4 - image on GCR \
5 - Documents (data) added in firestore collection \
6 - Service accounts \
7 - PubSub topic and Subscriptions \


---

# Wrap up and reflection

- how can we make this solution better, more or less production ready? what we need to add next in order to make the app more reliable? (decouple, functions)
- **Never push any kind of password, api keys, access tokens to a GIT repository! Instead, use a proper Secret Management tool for storing your sensitive information.**
- Avoid expoising your API without any Protection (gateway or lb)
- Going for Serverless is a good path for simplicity and low maintainability costs



# [NEXT STEP]
Live demo with a product team who is running all serverless handing millions of events
