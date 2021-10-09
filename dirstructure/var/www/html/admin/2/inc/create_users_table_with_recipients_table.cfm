<!-- DROP USERS TABLE AND RE-CREATE IT USING THE RECIPIENTS TABLE STARTS HERE -->

<cfquery name="dropusers" datasource="hermes">
    drop table users
    </cfquery>
    
    <cfquery name="createusers" datasource="hermes">
    CREATE TABLE users LIKE recipients
    </cfquery>
    
    <cfquery name="copyusers" datasource="hermes">
    INSERT INTO users SELECT * FROM recipients
    </cfquery>
    
    <cfquery name="alterusers" datasource="hermes">
    alter table users change recipient email VARBINARY(255)
    </cfquery>
    
    <!-- DROP USERS TABLE AND RE-CREATE IT USING THE RECIPIENTS TABLE ENDS HERE -->