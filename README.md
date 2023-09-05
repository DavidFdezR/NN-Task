# NN Task
## Connect with CountryLayer
- Added a Batch job to connect with Countrylayer.com which will pull all provided countries, will populate and/or update
values on the Country__c Object.

- The same batch is created as a Schedulable so by scheduling the batch on any time this can be run,
- A trigger is created to populate the information into all  leads with the same country.
  (Note: The search of country in Leads is performed by 2 letter code, 3 letter code and whole name).
- Apex code is ready for deployment with a 99.86% of coverage.
- Generic Stub class is added for using stub API
- SObjectBuilder is added for test data generation

## Validation Rule in Lead
- Validation rule is implemented on Lead that will prevent Owner change if No. of employees, Lead source and Country are
populated, except for Contract Manager and System administrator Profiles, for Contract Manager the No. of employees can be empty
for System administrator the country and No. of employees can be empty.

## Flow for Lead
- A record triggered flow is created to autopopulate the value of the Owner Since field in Lead to the Date/time
when the Owner change is performed.