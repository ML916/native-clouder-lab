import * as pulumi from "@pulumi/pulumi";
import * as gcp from "@pulumi/gcp";

const project = gcp.organizations.getProject({});

console.log("Create secret");
const secret = new gcp.secretmanager.Secret("secret", {
    secretId: "my-secret",
    replication: {
        automatic: true,
    },
});

const secret_version_data = new gcp.secretmanager.SecretVersion("secret-version-data", {
    secret: secret.name,

    // NOTE: Using secrets in scripts is terrible, don't copy this!!!!
    secretData: "secret-data",
});



console.log("Provide access");
const secret_access = new gcp.secretmanager.SecretIamMember("secret-access", {
    secretId: secret.id,
    role: "roles/secretmanager.secretAccessor",
    member: "my-service-account@gmail.com",
}, {
    dependsOn: [secret],
});



console.log("Deploy service")
const _default = new gcp.cloudrun.Service("default", {
    location: "us-central1",
    template: {
        spec: {
            containers: [{
                image: "gcr.io/cloudrun/hello",
                volumeMounts: [{
                    name: "a-volume",
                    mountPath: "/secrets",
                }],
            }],
            volumes: [{
                name: "a-volume",
                secret: {
                    secretName: secret.secretId,
                    items: [{
                        key: "1",
                        path: "my-secret",
                    }],
                },
            }],
        },
    },
}, {
    dependsOn: [secret_version_data],
});