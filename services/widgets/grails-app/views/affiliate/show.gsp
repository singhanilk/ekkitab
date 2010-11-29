
<%@ page import="widgets.Affiliate" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="affiliate" />
        <g:set var="entityName" value="${message(code: 'affiliate.label', default: 'Affiliate')}" />
        <title><g:message code="default.show.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
            <span class="menuButton"><g:link class="list" action="list"><g:message code="default.list.label" args="[entityName]" /></g:link></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.show.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="buttons">
                <g:form>
                    <g:hiddenField name="id" value="${af?.id}" />
                    <span class="button"><g:actionSubmit class="edit" action="edit" value="${message(code: 'default.button.edit.label', default: 'Edit')}" /></span>
                    <span class="button"><g:actionSubmit class="delete" action="delete" value="${message(code: 'default.button.delete.label', default: 'Delete')}" onclick="return confirm('${message(code: 'default.button.delete.confirm.message', default: 'Are you sure?')}');" /></span>
                </g:form>
            </div>
            <div class="dialog">
                <table>
                    <tbody>                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="affiliate.id.label" default="Id" /></td>                            
                            <td valign="top" class="value">${fieldValue(bean: af, field: "id")}</td>                            
                        </tr>                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="affiliate.name.label" default="Name" /></td>                            
                            <td valign="top" class="value">${fieldValue(bean: af, field: "name")}</td>                            
                        </tr>                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="affiliate.address.label" default="Address" /></td>                            
                            <td valign="top" class="value"><g:link controller="address" action="show" id="${af?.address?.id}">${af?.address?.encodeAsHTML()}</g:link></td>
                        </tr>                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="affiliate.creationDate.label" default="Creation Date" /></td>                            
                            <td valign="top" class="value"><g:formatDate date="${af?.creationDate}" /></td>                            
                        </tr>                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="affiliate.inactive.label" default="Inactive" /></td>                            
                            <td valign="top" class="value"><g:formatBoolean boolean="${af?.inactive}" /></td>                            
                        </tr>
                    
                        <tr class="prop">
                            <td valign="top" class="name"><g:message code="affiliate.updateDate.label" default="Update Date" /></td>                            
                            <td valign="top" class="value"><g:formatDate date="${af?.updateDate}" /></td>                            
                        </tr>                    
                    </tbody>
                </table>
            </div>
        </div>
    </body>
</html>
