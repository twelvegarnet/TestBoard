<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.Date"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:import url="/WEB-INF/views/layout/header.jsp" />
<link rel="stylesheet" href="/resources/css/pagination.css">
<fmt:formatDate value="<%=new Date() %>" pattern="yyMMdd" var="now" />

<style type="text/css">
</style>

<div class="content" style="width:1000px; margin: 0 auto; padding-top: 50px; min-height: 400px;">
	
	<div class="head" style="font-size: 20pt; font-weight: 700;">
		게시판
	</div>
	
	<div id="cntList" style="text-align: right;">
		<select id="listCount" onchange="chgListCnt()">
			<option value="10" id="ten">10개씩</option>
			<option value="20" id="twe">20개씩</option>
			<option value="30" id="thi">30개씩</option>
		</select>
	</div>
	
	<table style="width: 100%; padding-top: 10px; table-layout: fixed;">
		<tr id="list-head" class="list-head">
			<th style="width: 10%;"></th>
			<th style="width: 50%;" class="center">제목</th>
			<th style="width: 20%;">작성자</th>
			<th style="width: 10%;" class="center">작성일</th>
			<th style="width: 10%;" class="center">조회</th>
		</tr>
		<c:forEach var="b" items="${blist }">
			<fmt:formatDate value="${b.createDate }" pattern="yyMMdd" var="brd"/>
			<tr>
				<td class="center">${b.rownum }</td>
				<td style="padding-right: 20px; overflow: hidden; text-overflow: ellipsis;"><a id="title" class="title" href="/board/view?boardNo=${b.boardNo }" style="font-size: 15pt; white-space: pre;"><c:out value="${b.boardTitle }" escapeXml="true" /></a></td>
				<td style="padding: 0px 20px 0px 20px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis;">${b.boardNick }</td>
				<td class="center">
					<c:if test="${brd eq now }">
						<fmt:formatDate value="${b.createDate }" pattern="HH:mm" />
					</c:if>
					<c:if test="${brd ne now }">
						<fmt:formatDate value="${b.createDate }" pattern="yyyy.MM.dd" />
					</c:if>
				</td>
				<td class="center">${b.hit }</td>
			</tr>
		</c:forEach>
	</table>
	
	<div class="writeBtn">
		<button class="btn pull-right" onclick="location.href='/board/write'">글쓰기</button>
	</div>
	
	<c:import url="/WEB-INF/views/board/paging.jsp" />
	
	<div id="searchbox" style="text-align: center;">
		<select id="category" name="category" style="height: 25px;">
			<option value="mix">제목+내용</option>
			<option value="title">제목만</option>
			<option value="content">내용만</option>
			<option value="nick">글작성자</option>
		</select>
		<input type="text" id="search" name="search" style="height: 25px;" />
		<input type="button" onclick="search()" value="검색" style="height: 25px;" />
	</div>

</div>	<%-- content end --%>

<c:import url="/WEB-INF/views/layout/footer.jsp" />

<script type="text/javascript">
if(${listCount} === 10){
	$("#listCount").val("10").prop("selected", true);
} else {
	$("#listCount").val("${listCount}").prop("selected", true);
}

function search(){
	let category = $("#category").val();
	let search = $("#search").val();
	
	location.href = "/board/list?category="+category+"&search="+search;
}

function chgListCnt(){
	let category = '${paging.category}';
	let search = '${paging.search}';
	let listCount = $("#listCount").val();
	
	location.href = "/board/list?category="+category+"&search="+search+"&listCount="+listCount;
}
</script>

