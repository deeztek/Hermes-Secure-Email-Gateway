
<!---
Hermes Secure Email Gateway Copyright Dionyssios Edwards 2011-2021. All Rights Reserved.

This file is part of Hermes Secure Email Gateway Community Edition.

    Hermes Secure Email Gateway Community Edition is free software: you can redistribute it and/or modify
    it under the terms of the GNU Affero General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    Hermes Secure Email Gateway Community Edition is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Affero General Public License
    along with Hermes Secure Email Gateway Community Edition.  If not, see <https://www.gnu.org/licenses/agpl.html>.
--->

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