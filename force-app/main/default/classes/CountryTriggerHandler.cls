/**
 * @author David Fernandez
 * @date 05.09.2023
 *
 * @description Handler for Country__c Trigger
 */
public with sharing class CountryTriggerHandler {

    @TestVisible
    private LeadSelector leadSelectorImpl{
        get{
            if(leadSelectorImpl == null){
                leadSelectorImpl = new LeadSelector();
            }
            return leadSelectorImpl;
        }
        set;
    }
    public void updateRelatedLeads(List<Country__c> countries){
        List<Lead> updatedLeads =  new List<Lead>();
        for(Country__c country:countries){
            Set<String> possibleCountryNames = new Set<String>{
                    country.Name,country.alpha2Code__c,country.alpha3Code__c
            };
            List<Lead> foundLeads = leadSelectorImpl.selectByCountryNames(possibleCountryNames);
            for(Lead lead:foundLeads){
                lead.alpha2Code__c = country.alpha2Code__c;
                lead.alpha3Code__c = country.alpha3Code__c;
                lead.capital__c = country.capital__c;
                lead.Region__c = country.Region__c;
                lead.Regional_Blocs__c = country.Regional_Blocs__c;
            }
            updatedLeads.addAll(foundLeads);
        }
        if(updatedLeads.size()>0){
            update updatedLeads;
        }
    }
}