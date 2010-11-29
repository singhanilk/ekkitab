

<%@ page import="widgets.Affiliate" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="affiliate" />
        <g:set var="entityName" value="${message(code: 'affiliate.label', default: 'Affiliate')}" />
        <title><g:message code="default.create.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.create.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <g:hasErrors bean="${af}">
            <div class="errors">
                <g:renderErrors bean="${af}" as="list" />
            </div>
            </g:hasErrors>
            <g:form action="save" >
               <div class="buttons">
                    <span class="button"><g:submitButton name="create" class="save" value="${message(code: 'default.button.create.label', default: 'Create')}" /></span>
                </div>
                <div class="dialog">
                    <table>
                        <tbody>                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="name"><g:message code="affiliate.name.label" default="Name" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: af, field: 'name', 'errors')}">
                                    <g:textField name="name" value="${af?.name}" class="aname"/>
                                </td>
                            </tr>
                        
                            <tr class="prop address">
                                <td valign="top" class="name" colspan="2">
                                    <label><g:message code="affiliate.address.label" default="Address & Contact" /></label>
                                </td>
                            </tr>
                            <tr class="prop">    
                                <td valign="top" class="name">
                                    <label for="email"><g:message code="address.email.label" default="e-mail" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: af.address, field: 'email', 'errors')}">
                                    <g:textField name="email" with="75" value="${af?.address?.email}" />
                                </td>
                            </tr>    
                            <tr>
                                <td valign="top" class="name">
                                    <label for="addressLine1"><g:message code="address.addressLine1.label" default="Address Line1" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: af.address, field: 'addressLine1', 'errors')}">
                                    <g:textField name="addressLine1" class="addressLine" with="100" value="${af?.address?.addressLine1}" />
                                </td>
                            </tr>
                             <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="addressLine2"><g:message code="address.addressLine1.label" default="Address Line2" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: af.address, field: 'addressLine2', 'errors')}">
                                    <g:textField name="addressLine2" class="addressLine" value="${af?.address?.addressLine2}" />
                                </td>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="city"><g:message code="address.city.label" default="City" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: af.address, field: 'city', 'errors')}">
                                    <g:textField name="city" with="100" value="${af?.address?.city}" />
                                </td>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="state"><g:message code="address.state.label" default="State" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: af.address, field: 'state', 'errors')}">
                                    <g:textField name="state" with="100" value="${af?.address?.state}" />
                                </td>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="country"><g:message code="address.country.label" default="Country" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: af.address, field: 'country', 'errors')}">
                                    <g:textField name="country" with="100" value="${af?.address?.country}" />
                                </td>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="postalCode"><g:message code="address.postalCode.label" default="PIN Code" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: af.address, field: 'postalCode', 'errors')}">
                                    <g:textField name="postalCode" with="10" value="${af?.address?.postalCode}" />
                                </td>
                            </tr>
                            <!--  phone numbers  -->
                             <tr class="prop phones">
                                <td valign="top" class="name" colspan="2">
                                    <label><g:message code="affiliate.address.phone" default="Phone Numbers" /></label>
                                </td>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="phone"><g:message code="address.phone.label" default="Phone" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: af.address, field: 'phone', 'errors')}">
                                    <g:textField name="phone" with="10" value="${af?.address?.phone}" />
                                </td>
                            </tr>
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="mobilePhone"><g:message code="address.mobilePhone.label" default="Mobile" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: af.address, field: 'mobilePhone', 'errors')}">
                                    <g:textField name="mobilePhone" with="10" value="${af?.address?.mobilePhone}" />
                                </td>
                            </tr>

                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="creationDate"><g:message code="affiliate.creationDate.label" default="Creation Date" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: af, field: 'creationDate', 'errors')}">
                                    <g:datePicker name="creationDate" precision="day" value="${af?.creationDate}"  />
                                </td>
                            </tr>
                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="inactive"><g:message code="affiliate.inactive.label" default="Inactive" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: af, field: 'inactive', 'errors')}">
                                    <g:checkBox name="inactive" value="${af?.inactive}" />
                                </td>
                            </tr>                        
                            <tr class="prop">
                                <td valign="top" class="name">
                                    <label for="updateDate"><g:message code="affiliate.updateDate.label" default="Update Date" /></label>
                                </td>
                                <td valign="top" class="value ${hasErrors(bean: af, field: 'updateDate', 'errors')}">
                                    <g:datePicker name="updateDate" precision="day" value="${af?.updateDate}"  />
                                </td>
                            </tr>
                        
                        </tbody>
                    </table>
                </div>
            </g:form>
        </div>
    </body>
</html>
