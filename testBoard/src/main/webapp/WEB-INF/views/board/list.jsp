<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.Date"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:import url="/WEB-INF/views/layout/header.jsp" />
<link rel="stylesheet" href="/resources/css/pagination.css">

<fmt:formatDate value="<%=new Date() %>" pattern="yyMMdd" var="now" />
		
<div class="content" style="width:1000px; margin: 0 auto; padding-top: 50px; min-height: 400px;">
	
	<div class="head" style="font-size: 20pt; font-weight: 700;">
		게시판
		<form id="form1" name="form1" method="POST" enctype="multipart/form-data">
			<!-- <input type="file" id="fileInput" name="fileInput" class="btn pull-right" />
			<input type="button" class="btn pull-right" style="margin-right: 20px;" onclick="excelUpload()" value="엑셀파일 업로드" /> -->
			<input type="button" class="btn pull-right" style="margin-right: 20px;" onclick="excelDownload()" value="엑셀파일 다운로드" />
		</form>
	</div>
	
	<div id="cntList" style="text-align: right;">
		<input type="button" class="btn" value="전체 리스트" onclick="location.href='/board/list'" />
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
			<th style="width: 20%;">닉네임</th>
			<th style="width: 10%;" class="center">작성일</th>
			<th style="width: 10%;" class="center">조회</th>
		</tr>

		<c:forEach var="b" items="${blist }">
				<fmt:formatDate value="${b.createDate }" pattern="yyMMdd" var="brd" />
				<c:set var="f" value="${b.countFile }" />
				<tr>
					<td class="center">
					<%-- selectAll()를 사용했을 때 출력방식 --%>
					<%-- <c:if test="${b.layerNo eq 0 }">${b.rownum }</c:if> --%>
					<c:choose>
							<c:when test="${empty paging.search && b.layerNo eq 0 }">
								${b.rownum }
							</c:when>
							<c:when test="${not empty paging.search }">
								${b.rownum }
							</c:when>
						</c:choose>
					</td>
					<c:choose>
						<c:when test="${b.deleteStatus eq 'N'}">
							<td style="padding-right: 20px; overflow: hidden; padding-left: <c:out value='${20*b.layerNo }'/>px; text-overflow: ellipsis;"><a class="title" href="/board/view?boardNo=${b.boardNo }" style="white-space: pre;"><c:if test="${b.layerNo ne 0 }">└ </c:if><c:out value="${b.boardTitle }" escapeXml="true" /></a>&nbsp;[${b.countCmt }]&nbsp;<c:if test="${b.countFile ne 0 }"><c:forEach var="bb" items="${blist }"><c:if test="${f gt 0 }"><i class="far fa-file-image"></i><c:set var="f" value="${f-1 }" /></c:if></c:forEach></c:if></td>
						</c:when>
						<c:otherwise>
							<td style="padding-right: 20px; overflow: hidden; padding-left: <c:out value='${20*b.layerNo }'/>px; text-overflow: ellipsis;"><c:if test="${b.layerNo ne 0 }">└ </c:if>삭제된 게시글입니다.</td>
						</c:otherwise>
					</c:choose>
					<td style="padding: 0px 20px 0px 20px; overflow: hidden; white-space: nowrap; text-overflow: ellipsis; text-align: center;">${b.boardNick }</td>
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
	
	<div id="writeBtn" style="margin: 20px 0px; text-align: right;">
		<button class="btn" onclick="writeBoard()">글쓰기</button>
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

function writeBoard(){
	location.href = "/board/write";
}

function excelUpload(){
	var f = new FormData(document.getElementById('form1'));
	
    $.ajax({
        url: "uploadExcelFile",
        data: f,
        processData: false,
        contentType: false,
        type: "POST",
        success: function(data){
        	alert("업로드가 완료되었습니다.");
			location.href = "/board/list";
        }
    	, error: function(data){
    		alert("엑셀 파일(.xlsx)을 업로드 해주세요.");
    	}
    })
}

function excelDownload(){
	 var f = document.form1;
     f.action = "downloadExcelFile";
     f.submit();
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

