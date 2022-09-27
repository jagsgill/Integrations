# Integrations
This repository is for Integration examples using the Layer7 API Gateway. You will find examples of using the Layer7 API Gateway policy language to integrate with a variety of external systems. Examples of integrations may include message buses (MQ, JMS, AMQP, etc.), logging aggregators, authentication providers, etc.

## Here is a list of available integration examples

|Name|Brief Description|
|-----|-----------------|
|sample|This is a sample of how each example should be structured in the repository and should be used as a guideline for all contributions|
|[Gateway with Luna HSM](./gateway-luna-helm-sample)|This is a sample helm chart of gateway container integrates with Luna HSM|
|[Gateway OPA Example](./gateway-opa-example)|This example contains a very simple implementation of the Layer7 API Gateway calling out to OPA ([Open Policy Agent](https://www.openpolicyagent.org/docs/latest/)) for AuthN/Z decisions.|
|[Gateway Metrics](./gateway-metrics-grafana-example)|This example is an all-in-one / docker based container 9.4 gateway that includes the required Off-Box Metrics policy as well as four test policies and a script to make calls and generate traffic.|
|[Gateway Metrics Kubernetes](./gateway-metrics-grafana-kubernetes)|This example is similar to the Gateway Metrics sample but leverages the [Gateway Helm Charts](https://github.com/CAAPIM/apim-charts/tree/stable/charts/gateway) to start an ephemeral gateway with metrics off-boxing. The needed Off-Box policy is also provided as a bundle so that it can be added to an existing gateway.|

## Using the examples

Each example has its own structure and its own description. After downloading or cloning this project simply change into
 the directory of your target example and follow its instructions.

## Feedback
We are certainly happy about any feedback on these tutorials, especially if they helped you in your daily work life! We 
are also available via the [Layer7 Communities](https://community.broadcom.com/enterprisesoftware/communities/communityhomeblogs?CommunityKey=0f580f5f-30a4-41de-a75c-e5f433325a18)

## IMPORTANT
If any example has an issue, please do not contact Broadcom support. These examples are provided as-is. Please communicate via comments, pull requests and emails to the author of the tutorial if you have any issues or questions.

## Contribution Guidelines
To contribute examples, create a pull request with your updates. All pull requests require at least one reviewer to approve before the contribution will be merged to the main branch. Please ensure that all contributions follow the structure of the "sample" folder.
Each new example should:
- Be located in it's own folder
- Include a description in the README.md file in the folder with a description of the example along with instructions on how to use the example including any prerequisites
- Update the README.md on the main folder to add a name and brief description of the example

**Enjoy!**
