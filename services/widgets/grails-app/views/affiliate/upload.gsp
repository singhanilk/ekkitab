<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="layout" content="affiliate" />
        <title>Upload an Affiliate Catalog</title>
    </head>
    <body>
    	<div class="body">
    		<h1>Choose an XML file and click to refresh Affiliate Books Catalog</h1>
    		<div>
    			<g:form 
    				controller="affiliate" 
    				method="post" 
    				action="refresh" 
  					enctype="multipart/form-data">
    				<input type="file" name="file"/>
    				<g:submitButton name="Refresh" value="Refresh"/>
				</g:form>
    		</div>
    	</div>
    </body>
</html>    