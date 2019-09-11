<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- ${contextPath} 선언부입니다  -->

<c:set var="contextPath" value="${ pageContext.servletContext.contextPath }" scope="application"/>
<script src="http://code.jquery.com/jquery-3.4.1.min.js"></script> 
</head>

<body>
	
	<h1 align="center">임시 메뉴바</h1>
	<br>
	
	<div class="loginArea" align="right">
		<c:if test="${ empty sessionScope.loginUser }">
			<form action="login.dr" method="post">
				<table id="loginTable" style="text-align:center;">
					<tr>
						<td>이메일</td>
						<td><input type="email" name="userEmail"></td>
						<td rowspan="2">
							<button id="loginBtn">로그인</button>
						</td>
					</tr>
					<tr>
						<td>비밀번호</td>
						<td><input type="password" name="userPwd"></td>
					</tr>
					<tr>
						<td colspan="3">
							<a href="#">회원가입</a>
							<a href="#">아이디/비밀번호 찾기</a>
						</td>
					</tr>
				</table>
			</form>
		</c:if>
		<c:if test="${ !empty sessionScope.loginUser }">
			<h3 align="right">
				<c:out value="${ loginUser.userNickname }님 환영합니다!!"/>
				<c:url var="myinfo" value="#"/>
				<c:url var="logout" value="logout.dr"/>
				<button onclick="location.href='${myinfo}'">정보수정</button>
				<button onclick="location.href='${logout}'">로그아웃</button>
			</h3>
		</c:if>
	</div>
	
	<div class="menubar">
		<div class="nav">
			<div class="menu"><a href="home.dr">HOME</a></div>
		</div>
	</div>
	
	
</body>
</html>