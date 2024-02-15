# Multi region deployment of Azure AI services

There are several reasons why one might want to set up Azure OpenAI in multiple regions:

* Improved Performance: Setting up Azure OpenAI in multiple regions can help in reducing latency. When your application is hosted in multiple regions, the data doesn't need to travel as far to reach your users, leading to faster response times.
* High Availability: Having Azure OpenAI in multiple regions can provide a higher level of availability. In case of a failure or outage in one region, traffic can be redirected to another region, ensuring uninterrupted service.
* Disaster Recovery: A multi-region approach can also provide a robust disaster recovery solution. In the event of a catastrophic event impacting a whole region, you still have other regions as a fallback.
* Compliance and Data Residency: In certain industries or countries, there are regulations that require data to be stored in a specific geographical location. Deploying Azure OpenAI in multiple regions can help in meeting these compliance requirements.
*Scalability: Finally, deploying in multiple regions can provide more scalability. As your user base grows globally, you can add more regions to handle the increased traffic and demand.

## Single region

![Single region](./aoai_single_region.svg)
Single instance of the required services.

## Multi region

![Multi region](./aoai_multi_region.svg)
