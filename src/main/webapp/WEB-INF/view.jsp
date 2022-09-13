<%@ page language="java" contentType="text/html; charset=windows-1256"
	pageEncoding="windows-1256"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page isErrorPage="true"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="windows-1256">
<title>Event Details</title>
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
<c:if test="${error != null}">
			<div class="alert alert-danger" role="alert">
				<c:out value="${error}" />
			</div>
		</c:if>
		<c:if test="${success != null}">
			<div class="alert alert-success" role="alert">
				<c:out value="${success}" />
			</div>
		</c:if>
	</div>
	<div class="d-flex justify-content-center container">
		<div class="align-items-center">
			<div class="row ml-5 mt-1 ">
				<div class="span6">
					<div class="row ml-5 mt-2 mr-3 ">
						<h1 class="form-heading mb-5 mr-3">
							<c:out value="${myShow.title}"></c:out>
						</h1>

						<!-- ----------------------------------------------------------- -->
						<div class="row mb-3">
							<h4>
								Posted By:
								<c:out value="${myShow.postedBy}" />
							</h4>
						</div>

						<div class="row mb-3">
							<h4>
								Network:
								<c:out value="${myShow.network}" />
							</h4>
						</div>

						<div class="row mb-3">
							<h4>
								Description:
								<c:out value="${myShow.description}" />
							</h4>
						</div>

						<hr>
						<!-- --------------------------------- -->
						<table class="table table-hover display nowrap mt-4">
							<thead>
								<tr>
									<th colspan="1">user name</th>
									<th colspan="1">rate</th>
									
								</tr>
							</thead>
							<tbody>
								<c:forEach var="myRate" items="${rates}">
									<tr>
										
										<td><c:out value="${myRate.user.name}" /></td>
										<td><c:out value="${myRate.rate}" /></td>
										
									</tr>
								</c:forEach>
								
							</tbody>
						</table>
						<!-- -------------------------------- -->
						<form:form class="form align-items-right ml-4 mt-5" action="/rating/${myShow.id}"
							 modelAttribute="rate" method="POST">
							
							<div class="row mb-3">
							 <form:label class="form-label"  path="rate">rating:</form:label>
								<div class="col-12">
									<form:input type="number" path="rate" name="rating" cssClass="form-control" cssErrorClass="form-control is-invalid"/>
									<form:errors cssClass="invalid-feedback" path="rate"/>
								</div>
							</div>	
								<form:input type="hidden" path="user" value="${userId}"/>
								<form:input type="hidden" path="show" value="${myShow.id}"/>
							<div class="row mb-3">
								<div class="col-12">
									<button class="btn btn-large btn-dark" type="submit">Rate !</button>
								</div>
							</div>
						</form:form>
						<!-- -------------------------------- -->
						
						<!-- -------------------------------------------------------- -->
						<form class="form align-items-right ml-4 mt-5" action="/edit/${myShow.id}"
							method="GET">
							<button type="submit" class="btn btn-link text-right">Edit</button>
						</form>

					</div>

				</div>

			</div>
		</div>
	</div>
</body>
</html>