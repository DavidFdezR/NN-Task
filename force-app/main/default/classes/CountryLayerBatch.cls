/**
 * @author David Fernandez
 * @date 01.09.2023
 */
public with sharing class CountryLayerBatch implements
                Database.Batchable<SObject>,Database.AllowsCallouts,Database.Stateful,Schedulable{

    public CountryLayerService countryLayerServiceImpl{
        get{
            if(countryLayerServiceImpl == null){
                countryLayerServiceImpl = new CountryLayerService();
            }
            return countryLayerServiceImpl;
        }
        set;
    }

    public List<Country__c> start(Database.BatchableContext BC){
        return countryLayerServiceImpl.getExistingCountries();
    }

    public void execute(Database.BatchableContext Bc, List<Country__c> scope) {
        List<Country__c> updatedCountries = new List<Country__c>();
        for (Country__c oldInfo : scope) {
            String countryName = oldInfo.Name;
            Countrylayer_Country newInfo = countryLayerServiceImpl.retrievedCountries.get(countryName);
            Country__c isChanged = countryLayerServiceImpl.isModifiedCountry(oldInfo, newInfo);
            if (isChanged != null) {
                updatedCountries.add(isChanged);
            }
        }
        if (updatedCountries.size() > 0) {
            upsert updatedCountries;
        }
    }
    public void finish(Database.BatchableContext BC){}

    public void execute(SchedulableContext ctx){
        CountryLayerBatch batch = new CountryLayerBatch();
        Database.executeBatch(batch, 250);
    }

}