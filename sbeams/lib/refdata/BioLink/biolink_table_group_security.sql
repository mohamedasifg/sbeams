--$Id$
INSERT INTO table_group_security (privilege_id,record_status,created_by_id,date_created,date_modified,table_group,comment,modified_by_id,owner_group_id,work_group_id)
SELECT 20,'N',2,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'BioLink_infrastructure','',2,1,work_group_id FROM work_group WHERE work_group_name = 'BioLink_admin';
INSERT INTO table_group_security (privilege_id,record_status,created_by_id,date_created,date_modified,table_group,comment,modified_by_id,owner_group_id,work_group_id)
SELECT 25,'N',2,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'BioLink_infrastructure','',2,1,work_group_id FROM work_group WHERE work_group_name = 'BioLink_user';

INSERT INTO table_group_security (privilege_id,record_status,created_by_id,date_created,date_modified,table_group,comment,modified_by_id,owner_group_id,work_group_id)
SELECT 20,'N',2,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'common','',2,1,work_group_id FROM work_group WHERE work_group_name = 'BioLink_admin';
INSERT INTO table_group_security (privilege_id,record_status,created_by_id,date_created,date_modified,table_group,comment,modified_by_id,owner_group_id,work_group_id)
SELECT 20,'N',2,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'common','',2,1,work_group_id FROM work_group WHERE work_group_name = 'BioLink_user';

INSERT INTO table_group_security (privilege_id,record_status,created_by_id,date_created,date_modified,table_group,comment,modified_by_id,owner_group_id,work_group_id)
SELECT 30,'N',2,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'rowprivate','',2,1,work_group_id FROM work_group WHERE work_group_name = 'BioLink_admin';
INSERT INTO table_group_security (privilege_id,record_status,created_by_id,date_created,date_modified,table_group,comment,modified_by_id,owner_group_id,work_group_id)
SELECT 30,'N',2,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'rowprivate','',2,1,work_group_id FROM work_group WHERE work_group_name = 'BioLink_user';

INSERT INTO table_group_security (privilege_id,record_status,created_by_id,date_created,date_modified,table_group,comment,modified_by_id,owner_group_id,work_group_id)
SELECT 20,'N',2,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'project','',2,1,work_group_id FROM work_group WHERE work_group_name = 'BioLink_admin';
INSERT INTO table_group_security (privilege_id,record_status,created_by_id,date_created,date_modified,table_group,comment,modified_by_id,owner_group_id,work_group_id)
SELECT 20,'N',2,CURRENT_TIMESTAMP,CURRENT_TIMESTAMP,'project','',2,1,work_group_id FROM work_group WHERE work_group_name = 'BioLink_user';
