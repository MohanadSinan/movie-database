<%@ page language="java" contentType="text/html; charset=windows-1256"
	pageEncoding="windows-1256"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ page isErrorPage="true"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="windows-1256">
<title>Add Book</title>
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
	<div class="d-flex justify-content-center m-4 container">
		<div class="align-items-center">
			<div class="row ml-5 mt-1 ">
				<div class="span6">
					<div class="row ml-5 mt-2 mr-3 ">
					<div class="d-flex justify-content-between">
						<h1><c:out value="${show.title}"></c:out></h1>
						<form class="form align-items-right ml-4 mt-2" action="/dashboard" method="GET">
							<button type="submit" class="btn btn-link text-right">Go to Dashboard</button>
						</form>
						</div>
						<!-- ----------------------------------------------------------- -->
						<form:form  class="form align-items-center mt-4 ml-3" action="/process/${showId}" method="POST" 
						modelAttribute="show">							
						<div class="row mb-3">
						<input type="hidden" value="PUT" name="_method">
						
							 <form:label class="form-label" path="title">title:</form:label>
								<div class="col-12">
									<form:input type="text" path="title" cssClass="form-control" cssErrorClass="form-control is-invalid"/>
									<form:errors cssClass="invalid-feedback" path="title"/>
								</div>
							</div>	
							
							
							<div class="row mb-3">
							 <form:label class="form-label" path="network">network:</form:label>
								<div class="col-12">
									<form:input type="text" path="network" cssClass="form-control" cssErrorClass="form-control is-invalid"/>
									<form:errors cssClass="invalid-feedback" path="network"/>
								</div>
							</div>	
							
							
							<div class="row mb-3">
							 <form:label class="form-label" path="description">description:</form:label>
								<div class="col-12">
									<form:input type="text" path="description" cssClass="form-control" cssErrorClass="form-control is-invalid"/>
									<form:errors cssClass="invalid-feedback" path="description"/>
								</div>
							</div>	
								
							
							<div class="row mb-3">
								<div class="col-12">
									<button class="btn btn-large btn-dark" type="submit">Edit</button>
								</div>
							</div>
							
							

						</form:form>

					<form action="/delete/${show.id}" method="POST">
							<input type="hidden" name="_method" value="DELETE">
							 <input type="submit" value="delete" class="btn btn-link mb-1">				
					</form>
					</div>

				</div>

			</div>
		</div>
	</div>
</body>
</html>