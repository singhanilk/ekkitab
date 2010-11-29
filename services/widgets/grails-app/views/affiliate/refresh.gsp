<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="affiliate" />
        <title>Catalog Refresh Complete</title>
    </head>
    <body>
    	<div class="body">
    		<h1>Catalog has been successfully refreshed</h1>
    	</div>
		<div class="list" style="float:left;">
               <table>
                   <thead>
                       <tr>                       
                           <g:sortableColumn property="isbn" title="ISBN" />                        
                           <g:sortableColumn property="author" title="Author" />
                           <g:sortableColumn property="title" title="Title" />                        
                           <th>Image</th>                        
                           <g:sortableColumn property="MRP(Rs)" title="MRP" />
                           <g:sortableColumn property="Price(Rs)" title="Price" />
                           <g:sortableColumn property="discount" title="disount" />                        
                       </tr>
                   </thead>
                   <tbody>
                   <g:each in="${productList}" status="i" var="book">
                       <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">                        
                       	   <td>${book.isbn}</td>
                           <td><g:link url="${book.rawAuthorLink}">${book.author}</g:link></td>                        
                           <td><g:link url="${book.rawBookLink}"></g:link>${book.title}</td>                        
                           <td>
	                           	<a href="${book.rawBookLink}" title="${book.title}">
						   			<img src="<%=book.imageLink%>" 
											border="0" alt="<%=book.title%>" title="<%=book.title%>">
								</a>                           
                           </td>
                           <td>${book.mrp}</td>                                                
                           <td>${book.price}</td>                        
                           <td>${book.discount}</td>
                       </tr>
                   </g:each>
                   </tbody>
               </table>
           </div>
    </body>
</html>