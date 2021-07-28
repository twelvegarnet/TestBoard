<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:forEach var="c" items="${clist }">
	<div id="comments${c.cNo }" style="margin: 10px 10px 10px 0px; border-bottom: 1px solid #ccc;">
		<c:if test="${c.cNo eq standard}">
			<div>
				<label>닉네임</label>&nbsp;<label>${c.cNick }</label>
			</div>
			<div>
				<textarea id="updateComment" style="width: 100%; height: 100px; resize: none; margin-top: 20px;" 
				maxlength="300" onkeyup="countTextForUpdate()" required><c:out value="${c.cComment }" escapeXml="true" /></textarea>
				<label id="nowStrForUpdate">0</label>/<label id="limitStrForUpdate"></label>
				<input type="button" value="취소" onclick="updateCmtCancel()" style="float: right;" />
				<input type="button" value="완료" onclick="updateCmtFinish(${c.cNo})" style="float: right;" />
			</div>
		</c:if>
		<c:if test="${c.cNo ne standard }">
			<div>
				<label>닉네임</label>&nbsp;<label>${c.cNick }</label>
			</div>
			내용 &nbsp;<div style="width: 90%; white-space: break-spaces; word-wrap: break-word; margin: 10px 0px 10px 0px;"><c:out value="${c.cComment }" escapeXml="true" /></div>
			<input type="button" value="삭제" onclick="deleteCmt(${c.cNo},'${c.cPw }')" style="float: right;" />
			<input type="button" value="수정" onclick="updateCmt(${c.cNo},'${c.cPw }')" style="float: right;" />
			<div>
				<label>작성일</label>&nbsp;<label><fmt:formatDate value="${c.cCreateDate }" pattern="yyyy.MM.dd. HH:mm" /></label>
			</div>
		</c:if>
	</div>
</c:forEach>

<script type="text/javascript">
if(document.getElementById("updateComment")){
	const firstContent = $('#updateComment').val();
	let firstIncludeSpace = firstContent.length;
	$("#nowStrForUpdate").text(firstIncludeSpace);
}

const textareaLimitForUpdate = $('#updateComment').attr('maxlength')*1;
$("#limitStrForUpdate").text(textareaLimitForUpdate);

function countTextForUpdate(){
	const redex =  /\s/ig;
	let content = $('#updateComment').val();
	
	if(content.match(/(?<=\s)[가-힣a-zA-Z0-9]/) === null){
		let notIncludeSpace = content.toString().replace(redex, "").length;
		$("#nowStrForUpdate").text(notIncludeSpace);
	} else {
		let includeSpace = content.length;
		$("#nowStrForUpdate").text(includeSpace);
	}
}
</script>