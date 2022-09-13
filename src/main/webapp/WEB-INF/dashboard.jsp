<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Home</title>
<link rel="stylesheet" type="text/css" href="/css/style.css">
<script type="text/javascript" src="/js/app.js"></script>
<!-- for Bootstrap CSS -->
<link rel="stylesheet" href="/webjars/bootstrap/css/bootstrap.min.css" />
<!-- YOUR own local CSS -->
<link rel="stylesheet" href="/css/main.css" />
<!-- For any Bootstrap that uses JS or jQuery-->
<script src="/webjars/jquery/jquery.min.js"></script>
<script src="/webjars/bootstrap/js/bootstrap.min.js"></script>

</head>
<body>
	<div class="container">
		<div class="row mt-5">
			<div class="span6">
				<div class="d-flex justify-content-between">
					<h1 class="head">
						Welcome ,
						<c:out value="${nameString}" />
						!
					</h1>
					<p class="ml-4 mt-2">
						<a href="/logout">Logout</a>
					</p>
				</div>

				<div class="d-flex justify-content-between mt-3">
					<p>
						<a href="/add">Add Show</a>
					</p>
				</div>
				<div class="justify-content-center container ml-4">
					<div class="row mt-4">
						<p>TV Shows</p>
						<table class="table table-hover display nowrap mt-4">
							<thead>
								<tr>
									<th colspan="1">Show Title</th>
									<th colspan="1">Network</th>
									<th colspan="1">Average Rating </th>
									
								</tr>
							</thead>
							<tbody>
								<c:forEach var="myShow" items="${shows}">
									<tr>
										<td><a href="/view/${myShow.id}">
										<c:out value="${myShow.title}" />
										</a>
										</td>
										<td><c:out value="${myShow.network}" /></td>
										<td><c:out value="${myShow.avg}" /></td>
										
									</tr>
								</c:forEach>
								
							</tbody>
						</table>
					</div>
					<!-- --------------------------------------------------- -->
				
					
				</div>

			</div>
		</div>
	</div>
</body>
</html>

