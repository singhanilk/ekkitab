<div class="skyscraper">
<% productList.each { book -> %>
<div class="vColumns">
	<!-- one product -->
	<div class="discImageBox">
		<div class="image">
				<a href="#" onclick="<%=book.bookLink%>" 
				   title="<%=book.title%>">
				   <img src="<%=book.imageLink%>" 
				   		alt="<%=book.title%>" title="<%=book.title%>">
				</a>
		</div>
		<div class="bkdetails">
			<!--  discount -->
			<div class="<%=book.discount%>"></div>
			<!--  title etc -->
			<div class="titleEtc">
				<!-- bkTitle -->
				<div class="bkTitleHome">
					<a href="#" onclick="<%=book.bookLink%>" 
					   title="<%=book.title%>">
					   <%=book.displayTitle%>
					</a>
				</div>
				<!-- author -->
				<div class="authorHome">
					by 
					<a href="#" onclick="<%=book.authorLink%>">
						<%=book.author%>
					</a>
				</div>
				<!-- price -->
				<div class="youSave">
					Rs <%=book.price%>
				</div>
				<!-- mrp -->
				<div class="lineHeight14em">
					<span class="greyFont">MRP: Rs <%=book.mrp%></span>
				</div>
			</div>
		</div>
	</div>
</div>
<%}%>
</div>
