
set @resourceName = IFNULL(@resourceName,'{{ resourceName }}');

set @resourceImplementingInterface = 'edu.harvard.hms.dbmi.bd2k.irct.ri.scidb.SciDBResourceImplementation';
set @resourceURL = IFNULL(@resourceURL,'{{ scidb_url }}');

set @userName = IFNULL(@userName,'{{ username }}');
set @password = IFNULL(@password,'{{ password }}');

-- SET THE RESOURCE VARIABLE
set @resourceId = (select IFNULL(max(id), 1) from Resource) + 1;
insert into Resource(id, implementingInterface, name, ontologyType) VALUES
  (@resourceId, @resourceInterfaceClass, @resourceName, 'TREE');

-- INSERT THE RESOURCE PARAMERTERS
insert into resource_parameters(id, name, value) values(@resourceId, 'resourceName', @resourceName);
insert into resource_parameters(id, name, value) values(@resourceId, 'resourceURL', @resourceURL);
insert into resource_parameters(id, name, value) values(@resourceId, 'username', @userName);
insert into resource_parameters(id, name, value) values(@resourceId, 'password', @password);

-- SET THE RESOURCE PREDICATES
set @predicatetype_AFL = (select IFNULL(max(id), 1) from PredicateType) + 1;
insert into PredicateType(id, defaultPredicate, description, displayName, name) values(@predicatetype_AFL, 0, 'iQuery', 'AFL Query', 'AFL');

-- SET THE FIELDS
set @field_IQUERY = (select IFNULL(max(id), 1) from Field) + 1;
insert into Field(id, description, name, path, relationship, required) values(@field_IQUERY, 'iQuery', 'iQuery query string', 'IQUERY', null, 1);

-- Add the field to the PREDICATE
insert into PredicateType_Field(PredicateType_id, fields_id) values(@predicatetype_AFL, @field_IQUERY);

-- Finally add the PREDICATE to the RESOURCE
insert into Resource_PredicateType(Resource_Id, supportedPredicates_id) values(@resourceId, @predicatetype_AFL);
