/* LDAPAuth class for logging into Temple University systems using LDAP.
 * Copyright (c) 2015 Viraj Chitnis. All Rights Reserved.
 * 
 * Setup:
 * 1. Add this class to your project and change its 'namespace' to match your namespace (usually same as project name).
 * 2. Right click on you project in the solution explorer and select 'Add Reference...'.
 * 3. Use the search bar on the top right corner of the 'Reference Manager' window to search for 'directory'.
 * 4. From the search results, checkmark 'System.DirectoryServices' and 'System.DirectoryServices.Protocols'.
 * 5. Click 'Ok' at the bottom fo the window to finish.
 * 6. Add 'using System.Collections.Generic;' to top of the C# code which you wish to use this class in.
 * 
 * Declaration:
 *      LDAPAuth auth = new LDAPAuth(username, password);
 * 
 * Methods:
 *  All methods take a reference to a string variable as a parameter. If there is an error during the LDAP connection,
 *  the error message will be put into this variable. You may use this error message in your implementation of LDAPAuth.cs
 *  as you see fit.
 *      - TryLogin(out string errMessage)
 *          Simply login without any verification of attributes. If the entered tuaccessnet username and password
 *          is correct, this type of login will succeed.
 *          Example usage:
 *              string errMessage = ""; // If there is an error, the error message will be put into this variable
 *              string successOrNot = auth.TryLogin(out errMessage);
 *      - TryLogin(Dictionary<string, string[]> LDAPFieldsAndValuesToVerify, out string errMessage)
 *          This method accepts a dictionary of fields and values that should be verified before successfule login.
 *          If on the of provided fields does not exists, the login fails.
 *          As long as at least one of the value provided for each field matches, the login is successful.
 *          Example usage:
 *              string errMessage = ""; // If there is an error, the error message will be put into this variable
 *              Dictionary<string, string[]> fieldsToCheck = new Dictionary<string, string[]>(); // Declare dictionary
 *              string[] edupersonaffiliation = { "student", "member" }; // Array of values for field 'edupersonaffiliation'
 *              fieldsToCheck.Add("edupersonaffiliation", edupersonaffiliation); // Add field and value to dictionary
 *              string successOrNot = auth.TryLogin(fieldsToCheck, out errMessage); // Call TryLogin method with dictionary as parameter
 *      Both the above methods return 'success' for successful logins, and 'failure' for failed logins.
 *      - TryLoginAndGetAllAttributes(out string errMessage)
 *          Simply login without any verification of attributes. If the entered tuaccessnet username and password
 *          is correct, this type of login will succeed. This method also returns all the LDAP attributes of the user as a
 *          dictionary that can be used in your code as you see fit.
 *          Example usage:
 *              string errMessage = ""; // If there is an error, the error message will be put into this variable
 *              Dictionary<string, string[]> LDAPAttributes = auth.TryLoginAndGetAllAttributes(out errMessage);
 */

using System;
using System.Net;
using System.DirectoryServices;
using System.DirectoryServices.Protocols;
using System.Security.Permissions;
using System.Collections.Generic;
using SearchScope = System.DirectoryServices.Protocols.SearchScope;

namespace LDAPAuth
{
    [DirectoryServicesPermission(SecurityAction.LinkDemand, Unrestricted = true)]

    public class LDAPAuth
    {
        private LdapConnection ldapConnection;
        private string ldapServer;
        private string username;
        private string password;
        private string targetOU;
        private Dictionary<string, string[]> attributes;

        public LDAPAuth(String usr, String pwd)
        {
            ldapServer = "ldap-r.temple.edu:636";
            username = usr;
            password = pwd;
            targetOU = "ou=people,dc=temple,dc=edu";
            attributes = new Dictionary<string, string[]>();
        }

        // Simply login without verifying any extra LDAP fields.
        public String TryLogin(out string errMessage)
        {
            errMessage = DoLoginAndGetAttributes();

            if (attributes.Count > 0)
            {
                return "success";
            }
            else
            {
                return "failure";
            }
        }

        // Verify certain LDAP field values before allowing login. This may be used to restrict logins to only TU faculty, or only TU students, etc.
        public String TryLogin(Dictionary<string, string[]> LDAPFieldsAndValuesToVerify, out string errMessage)
        {
            bool success = false;
            errMessage = DoLoginAndGetAttributes();

            if (attributes.Count > 0)
            {
                foreach (KeyValuePair<string, string[]> field in LDAPFieldsAndValuesToVerify)
                {
                    if (attributes.ContainsKey(field.Key))
                    {
                        bool thisFieldSuccess = false;
                        foreach (string value in field.Value)
                        {
                            int valuePosition = Array.IndexOf(attributes[field.Key], value);
                            if (valuePosition > -1)
                            {
                                thisFieldSuccess = true;
                            }
                        }

                        if (thisFieldSuccess)
                        {
                            success = true;
                        }
                        else
                        {
                            success = false;
                        }
                    }
                    else
                    {
                        return "failure";
                    }
                }

                if (success)
                {
                    return "success";
                }
                else
                {
                    return "failure";
                }
            }
            else
            {
                return "failure";
            }
        }

        // Login and get all LDAP fields and values to be used in your own code.
        // To check if login was successful, check the count of the returned dictionary object, a failed login will have 0 count.
        public Dictionary<string, string[]> TryLoginAndGetAllAttributes(out string errMessage)
        {
            errMessage = DoLoginAndGetAttributes();

            return attributes;
        }

        // This method is mainly meant for testing purposes.
        public String TryLoginAndGetValueOfAttribute(string attributeName, out string errMessage)
        {
            errMessage = DoLoginAndGetAttributes();

            if (attributes.Count > 0)
            {
                if (attributes.ContainsKey(attributeName))
                {
                    return "success " + arrayToString(attributes[attributeName]);
                }
                else
                {
                    return "failure";
                }
            }
            else
            {
                return "failure";
            }
        }

        private String DoLoginAndGetAttributes()
        {
            ldapConnection = new LdapConnection(ldapServer);
            ldapConnection.SessionOptions.SecureSocketLayer = true;
            ldapConnection.AuthType = AuthType.Basic;
            ldapConnection.Credential = new NetworkCredential(String.Empty, String.Empty);

            using (ldapConnection)
            {
                try
                {
                    SearchRequest request = new SearchRequest(targetOU, "(uid=" + username + ")", SearchScope.Subtree);
                    SearchResponse response = (SearchResponse)ldapConnection.SendRequest(request);

                    string dn = "";
                    if (response.Entries.Count > 0)
                    {
                        SearchResultEntry entry = response.Entries[0];
                        dn = entry.DistinguishedName;

                        ldapConnection.Credential = new NetworkCredential(dn, password);

                        ldapConnection.Bind();
                        request = new SearchRequest(targetOU, "(uid=" + username + ")", SearchScope.Subtree);
                        response = (SearchResponse)ldapConnection.SendRequest(request);

                        if (response.Entries.Count > 0)
                        {
                            entry = response.Entries[0];

                            foreach (string attributeName in entry.Attributes.AttributeNames)
                            {
                                string attributeValue = "";
                                for (int i = 0; i < entry.Attributes[attributeName].Count; i++)
                                {
                                    attributeValue = attributeValue + entry.Attributes[attributeName][i].ToString();

                                    if (i < (entry.Attributes[attributeName].Count - 1))
                                    {
                                        attributeValue = attributeValue + ",";
                                    }
                                }

                                attributes.Add(attributeName, attributeValue.Split(','));
                            }

                            return "success";
                        }
                        else
                        {
                            return "failure";
                        }
                    }
                    else
                    {
                        return "failure";
                    }
                }
                catch (Exception e)
                {
                    attributes = new Dictionary<string, string[]>();
                    return e.Message;
                }
            }
        }

        public String DoLoginAndGetDN()
        {
            ldapConnection = new LdapConnection(ldapServer);
            ldapConnection.SessionOptions.SecureSocketLayer = true;
            ldapConnection.AuthType = AuthType.Basic;
            ldapConnection.Credential = new NetworkCredential(String.Empty, String.Empty);

            using (ldapConnection)
            {
                try
                {
                    SearchRequest request = new SearchRequest(targetOU, "(uid=" + username + ")", SearchScope.Subtree);
                    SearchResponse response = (SearchResponse)ldapConnection.SendRequest(request);

                    string dn = "";
                    if (response.Entries.Count > 0)
                    {
                        SearchResultEntry entry = response.Entries[0];
                        return dn = entry.DistinguishedName;
                    }
                    else
                    {
                        return "Username not found.";
                    }
                }
                catch (Exception e)
                {
                    attributes = new Dictionary<string, string[]>();
                    return e.Message;
                }
            }
        }

        private String arrayToString(string[] arr)
        {
            string ret = string.Join(",", arr);
            return ret;
        }
    }
}