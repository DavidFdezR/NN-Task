/**
 * @author David Fernandez
 * @date 01.09.2023
 */
public with sharing class CountryLayerService {

    private final Map<String, String> fieldsMapping = new Map<String, String>{
          'Name'=>'name',
          'alpha2Code__c' => 'alpha2Code',
          'alpha3Code__c' => 'alpha3Code',
          'capital__c'=> 'capital',
          'Region__c'=> 'region'
    };

    private final Map<Boolean,String> CREDENTIAL_PER_ENV = new Map<Boolean, String>{
            true => 'Development',
            false => 'Production'
    };

    public Boolean runningInASandbox {
        get {
            if (runningInASandbox == null) {
                runningInASandbox = [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
            }
            return runningInASandbox;
        }
        set;
    }

    @TestVisible
    private CountryLayerSelector countryLayerSelectorImpl{
        get{
            if(countryLayerSelectorImpl == null){
                countryLayerSelectorImpl = new CountryLayerSelector();
            }
            return countryLayerSelectorImpl;
        }
        set;
    }

    public Map<String, Countrylayer_Country> retrievedCountries{
        get{
            if(retrievedCountries == null){
                retrievedCountries = getCountriesInfo();
            }
            return retrievedCountries;
        }
        set;
    }

    @TestVisible
    private String getApiValue(){
        String env_credential = CREDENTIAL_PER_ENV.get(runningInASandbox);
        return countryLayerSelectorImpl.selectApiKeyByName(env_credential).API_KEY__c;
    }

    public Map<String, Countrylayer_Country> getCountriesInfo(){
        List<Countrylayer_Country> retrievedCountries = new List<Countrylayer_Country>();
        Map<String, Countrylayer_Country> results = new Map<String, Countrylayer_Country>();
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:CountryLayer?access_key=' + getApiValue());
        request.setMethod('GET');
        request.setHeader('Content-Type','application/json;charset=UTF-8');
        HttpResponse response = http.send(request);
        if(response.getStatusCode() == 200){
            retrievedCountries = (List<Countrylayer_Country>) JSON.deserialize(response.getBody(),List<Countrylayer_Country>.class);
        }
        for(Countrylayer_Country retrievedCountry : retrievedCountries){
            if(!results.containsKey(retrievedCountry.name)){
                results.put(retrievedCountry.name,retrievedCountry);
            }
        }
        return results;
    }

    public Country__c isModifiedCountry(Country__c existing, Countrylayer_Country retrieved){
        Boolean isChanged = false;
        for(String fieldName: fieldsMapping.keySet()){
            String countryLayerField = fieldsMapping.get(fieldName);
            Object oldValue  = existing.get(fieldName);
            Object newValue = retrieved.get(countryLayerField);
            if(oldValue != newValue){
                existing.put(fieldName,newValue);
                isChanged = true;
            }
        }
        if(isChanged){
            return existing;
        }
        else{
            return null;
        }
    }

    public List<Country__c> getExistingCountries(){
       List<Country__c> result =  countryLayerSelectorImpl.selectExistingCountries();
        retrievedCountries = getCountriesInfo();
        //This will only be executed the first time the batch runs as the object doesn't have any records
        if(result.size() == 0){
            List<Country__c> missing = new List<Country__c>();
            for(Countrylayer_Country existingCountry : retrievedCountries.values()){
                missing.add(isModifiedCountry(new Country__c(), existingCountry));
            }
            insert missing;
            result = countryLayerSelectorImpl.selectExistingCountries();
        }
        return result;
    }
}