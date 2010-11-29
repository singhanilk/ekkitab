
<%@ page import="widgets.Affiliate" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="affiliate" />
        <g:set var="entityName" value="${message(code: 'affiliate.label', default: 'Affiliate')}" />
        <title><g:message code="default.list.label" args="[entityName]" /></title>
    </head>
    <body>
        <div class="nav">
            <span class="menuButton"><a class="home" href="${createLink(uri: '/')}"><g:message code="default.home.label"/></a></span>
            <span class="menuButton"><g:link class="create" action="create"><g:message code="default.new.label" args="[entityName]" /></g:link></span>
        </div>
        <div class="body">
            <h1><g:message code="default.list.label" args="[entityName]" /></h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div class="list">
                <table>
                    <thead>
                        <tr>
                        
                            <g:sortableColumn property="id" title="${message(code: 'affiliate.id.label', default: 'Id')}" />                        
                            <g:sortableColumn property="name" title="${message(code: 'affiliate.name.label', default: 'Name')}" />                        
                            <th><g:message code="affiliate.address.label" default="Address" /></th>                        
                            <g:sortableColumn property="creationDate" title="${message(code: 'affiliate.creationDate.label', default: 'Creation Date')}" />
                            <g:sortableColumn property="inactive" title="${message(code: 'affiliate.inactive.label', default: 'Inactive')}" />                        
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${aflist}" status="i" var="af">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">                        
                            <td><g:link action="show" id="${af.id}">${fieldValue(bean: af, field: "id")}</g:link></td>                        
                            <td>${fieldValue(bean: af, field: "name")}</td>                        
                            <td>${fieldValue(bean: af, field: "address")?.encodeAsHTML()}</td>                        
                            <td><g:formatDate date="${af.creationDate}" /></td>                        
                            <td><g:formatBoolean boolean="${af.inactive}" /></td>                        
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
            <div class="paginateButtons">
                <g:paginate total="${total}" />
            </div>
        </div>
    </body>
</html>
