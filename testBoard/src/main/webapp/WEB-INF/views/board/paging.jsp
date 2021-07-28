<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${not empty paging.category }">
	<c:set var="category" value="&category=${paging.category }" />
</c:if>
<c:if test="${not empty paging.search }">
	<c:set var="search" value="&search=${paging.search }" />
</c:if>
<c:if test="${not empty paging.listCount }">
	<c:set var="listCount" value="&listCount=${paging.listCount }" />
</c:if>

<div class="text-center" style="text-align: center;">
	<ul class="pagination">
	
		<%-- 처음 페이지 버튼 --%>
		<%-- 첫 페이지가 아닐 때 버튼 노출 --%>
		<c:if test="${paging.startPage ne 1 }">
		  <li><a href="/board/list?curPage=1${category}${search}${listCount}"><span>&lt;&lt;</span></a></li>
		</c:if>
	
		<%-- 이전 페이징 리스트로 가기 --%>
		<c:choose>
			<c:when test="${paging.startPage gt paging.pageCount }">
				<li>
				<a href="/board/list?curPage=${paging.startPage - paging.pageCount }${category}${search}${listCount}"
				style="border: none; color: black; margin: 0px 5px;">&lt;이전</a></li>
			</c:when>
			<c:otherwise>
			</c:otherwise>
		</c:choose>
		
		<%-- 페이징 리스트 --%>
		<c:forEach var="i" begin="${paging.startPage }" end="${paging.endPage }" step="1">
			<c:choose>
				<c:when test="${paging.pageCount eq 0 }">
					<li><a href="/board/list?curPage=1"
					style="color: black; margin: 0px 5px;">1</a></li>
				</c:when>
				<c:when test="${i eq paging.curPage }">
					<li><a href="/board/list?curPage=${i }${category}${search}${listCount}"
					style="color: red; border: 1px solid #ccc; margin: 0px 5px;">${i }</a></li>
				</c:when>
				<c:otherwise>
					<li><a href="/board/list?curPage=${i }${category}${search}${listCount}"
					style="border: none; color: black; margin: 0px 5px;">${i }</a></li>
				</c:otherwise>
			</c:choose>
		</c:forEach>
		
		<%-- 다음 페이징 리스트로 가기 --%>
		<c:choose>
			<c:when test="${paging.endPage ne paging.totalPage }">
				<li><a href="/board/list?curPage=${paging.startPage + paging.pageCount }${category}${search}${listCount}"
				style="border: none; color: black; margin: 0px 5px;">다음 &gt;</a></li>
			</c:when>
			<c:otherwise>
			</c:otherwise>
		</c:choose>
		
		<%-- 마지막 페이지 버튼 --%>
		<%-- 마지막 페이지가 아닐 때 버튼 노출 --%>
		<c:if test="${paging.endPage ne paging.totalPage }">
			<li><a href="/board/list?curPage=${paging.totalPage }${category}${search}${listCount}"><span>&gt;&gt;</span></a></li>
		</c:if>


		
	</ul>
</div>