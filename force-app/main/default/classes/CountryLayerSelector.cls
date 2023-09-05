/**
 * @author David Fernandez
 * @date 01.09.2023
 */
public with sharing class CountryLayerSelector {
    public CountryLayer_API__mdt selectApiKeyByName(String label){
        return [SELECT API_KEY__c FROM CountryLayer_API__mdt WHERE MasterLabel =:label LIMIT 1];
    }

    public List<Country__c> selectExistingCountries(){
        return [SELECT Id, Name, alpha2Code__c, alpha3Code__c, capital__c, Region__c, Regional_Blocs__c FROM Country__c];
    }
}