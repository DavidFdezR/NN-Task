/**
 * Created by david on 05.09.2023.
 */

trigger CountryTrigger on Country__c (after insert, after update) {
    new CountryTriggerHandler().updateRelatedLeads(Trigger.new);
}