<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:import url="/WEB-INF/views/layout/header.jsp" />

<style type="text/css">
#boardContent {
	word-wrap: break-word;
    white-space: pre-wrap;
    white-space: -moz-pre-wrap;
    white-space: -pre-wrap;
    white-space: -o-pre-wrap;
    word-break:break-all;
}

.texttag:hoever, .texttag:visited, .texttag:link {
	color: black;
	text-decoration: none;
}
</style>

<div id="content" style="width: 1000px; margin: 0 auto; padding-top: 25px;">
	
	<div id="backToList">
		<a class="backToList" href="/board/list" style="font-size: 17pt;"> 게시판으로 &gt;</a>
	</div>
	
	<div id="title" style="font-size: 25pt; word-wrap: break-word;"><c:out value="${board.boardTitle }" escapeXml="true" /></div>
	
	<div id="userData">
		<div>닉네임 : ${board.boardNick }</div>
		<div style="color: #ccc">
			작성일 : <fmt:formatDate value="${board.createDate }" pattern="yyyy.MM.dd. HH:mm" />&nbsp;&nbsp;
			<label style="font-weight:500;">조회&nbsp;${board.hit }</label>
		</div>
	</div>
	<hr>
	
	<div id="boardContent" style="min-height: 400px; white-space: break-spaces; font-size: 15pt;"><label>내용</label><br><c:out value="${board.boardContent }" escapeXml="true" /></div>
	<div id="fileBox">
		<c:forEach var="f" items="${file }">
			<a href="/board/download?bfNo=${f.bfNo }" style="display: inline-block; text-align: center;"><img src="/resources/${f.bfStoredName }" style="width: 300px; height: 200px; margin: 10px;"><br><button>다운로드</button></a>
		</c:forEach>
	</div>

</div> <%-- content end --%>

<div id="btnBox" style="width: 1000px; margin: 40px auto; padding: 20px; text-align: center; border-bottom: 1px solid #ccc;">
	<c:if test="${board.layerNo ge 0 && board.layerNo lt 5 }">
		<button style="float:left;" onclick="writeReply()">답글쓰기</button>
	</c:if>
	<input class="btn" type="button" onclick="updateBoard()" value="수정" />
	<button class="btn" onclick="deleteBoard()">삭제</button>
	<button class="btn" onclick="toList()">목록</button>
</div>

<div id="cmtBox" style="width: 1000px; margin: 30px auto;">
	<div style="font-size: 15pt; margin-bottom: 10px;">댓글 쓰기</div>
	<div>
		<div style="width: 70px; display:inline-block;">닉네임</div>&nbsp;<input type="text" id="cmtNick" name="boardNick" maxlength="20" onkeyup="nickKeyupChk(this)" onblur="nickBlurChk()" />
		<label id="cmtNickStandard">닉네임은 한글 1~10자 혹은 영어, 숫자 2~20자로 구성되어야 합니다</label>
		<label id="cmtNickWarn" class="nodisplay" style="color: red;">한글 1~10자, 영문, 숫자 2~20자만 사용 가능합니다.</label>
		<label id="cmtNickOk" class="nodisplay" style="color: green;">올바른 형식입니다.</label>
	</div>
	<div id="cmtPassword">
		<div style="width: 70px; display:inline-block;">비밀번호</div>&nbsp;<input type="password" id="cmtPw" name="boardPw" maxlength="10" onkeyup="pwKeyupChk(this)" onblur="pwBlurChk()" />
		<i class="fas fa-eye" style="cursor: pointer;"></i>
		<label id="cmtPwStandard">비밀번호는 6 ~ 10자 사이의 영어/숫자/특수문자로 구성되어야 합니다.</label>
		<label id="cmtPwWarn" class="nodisplay" style="color: red;">비밀번호는 6 ~ 10자 사이의 영어/숫자/특수문자로 구성되어야 합니다.</label>
		<label id="cmtPwOk" class="nodisplay" style="color: green;">올바른 형식입니다.</label>
	</div>
	<div>
		<textarea id="commentContent" name="cComment" placeholder="댓글을 입력해보세요."
		style="width: 100%; height: 100px; resize: none; margin-top: 20px;" maxlength="300" onkeyup="countText()" required></textarea>
		<label id="nowStr">0</label>/<label id="limitStr"></label>
		<input type="button" value="완료" onclick="writeCmt()" style="float: right;"/>
	</div>
	<hr>
	
	<div id="cmtList" style="width: 1000px; margin: 20px auto;">
		<c:forEach var="c" items="${clist }">
			<div id="comments${c.cNo }" style="margin: 10px 10px 10px 0px; border-bottom: 1px solid #ccc;">
				<div>
					<label>닉네임</label>&nbsp;<label>${c.cNick }</label>
				</div>
				내용 &nbsp;<div style="width: 90%; white-space: break-spaces; word-wrap: break-word; margin: 10px 0px 10px 0px;"><c:out value="${c.cComment }" escapeXml="true" /></div>
				<input type="button" value="삭제" onclick="deleteCmt(${c.cNo}, '${c.cPw }')" style="float: right;" />
				<input type="button" value="수정" onclick="updateCmt(${c.cNo}, '${c.cPw }')" style="float: right;" />
				<div>
					<label>작성일</label>&nbsp;<label><fmt:formatDate value="${c.cCreateDate }" pattern="yyyy.MM.dd. HH:mm" /></label>
				</div>
			</div>
		</c:forEach>
	</div>
</div>

<c:import url="/WEB-INF/views/layout/footer.jsp" />

<script type="text/javascript">
$(document).ready(function(){
	$('#cmtPassword i').on('click',function(){
        $('#cmtPw').toggleClass('active');
        if($('#cmtPw').hasClass('active')){
            $(this).attr('class',"fas fa-eye-slash")
            .prev('#cmtPw').attr('type',"text");
        }else{
            $(this).attr('class',"fas fa-eye")
            .prev('#cmtPw').attr('type','password');
        }
    });
});

const textareaLimit = $('#commentContent').attr('maxlength')*1;
$("#limitStr").text(textareaLimit);

const updateChk = true;

function toList(){
	location.href = "/board/list";
}

function writeReply(){
	const parentNo = ${board.boardNo};
	
	location.href = '/board/write?parentNo='+parentNo; /* 답글 쓰기 페이지로 이동 */
}

function updateBoard(){
	const pwchk = prompt("비밀번호를 입력해주세요.");
	if(pwchk === '${board.boardPw}'){
		location.href = '/board/update?boardNo=${board.boardNo}';
	} else {
		alert("정확한 비밀번호를 입력해주세요.");
	}
}

function deleteBoard(){
	const chk = confirm("게시글을 삭제하시겠습니까?");
	if(chk){
		const pwchk = prompt("비밀번호를 입력해주세요.");
		if(pwchk === '${board.boardPw}'){
			location.href = "/board/delete?boardNo="+${board.boardNo};
		} else{
			alert("정확한 비밀번호를 입력해주세요.");
		}
		
	} else {
		return;
	}
}

function nickKeyupChk(obj){
	const space = /\s/;
	const specialChar = /[<>\\/#?!@$%^&*-]/;
	const cmtNickCheck = /[^가-힣a-zA-Z0-9]{1,}/;
	if(space.exec(obj.value) || specialChar.exec(obj.value)){
		alert("닉네임에 공백과 특수문자를 사용할 수 없습니다.");
		obj.focus();
		obj.value = obj.value.replace(/[^가-힣a-zA-Z0-9]/g,"");
	}
	
	/* 입력된 값을 받아서 한글과 영어의 길이를 다르게 계산하고, 계산된 길이가 오버되면 짤라준다 */
	const cmtNickname = obj.value;
	const cmtNickMinLeng = 2;
	const cmtNickMaxLeng = $("#cmtNick").attr('maxlength')*1;
	let cmtNickLeng = 0;
	
	const cmtNickStandard = document.querySelector("#cmtNickStandard");
	const cmtNickWarn = document.querySelector("#cmtNickWarn");
	const cmtNickOk = document.querySelector("#cmtNickOk");
	const nodisplay = 'nodisplay';
	
	for(let i=0; i<cmtNickname.length; i++){
		cmtNick = obj.value.charAt(i);
		if(escape(cmtNick).length > 4){
			cmtNickLeng += 2;
		} else {
			cmtNickLeng += 1;
		}
	}
	
	if(cmtNickLeng >= cmtNickMinLeng && cmtNickLeng <= cmtNickMaxLeng){
		/* 닉네임 길이가 최대길이와 최소길이 범위 내일 때 */
		if(cmtNickCheck.test(cmtNickname)){
			cmtNickStandard.classList.add(nodisplay);
			cmtNickWarn.classList.remove(nodisplay);
			cmtNickOk.classList.add(nodisplay);
			
		} else {
			cmtNickStandard.classList.add(nodisplay);
			cmtNickWarn.classList.add(nodisplay);
			cmtNickOk.classList.remove(nodisplay);
		}

	} else if(cmtNickLeng > cmtNickMaxLeng) {
		/* 닉네임 길이가 최대길이보다 클 때 */
		let newCmtNickLeng = cmtNickLeng*1;
		let newCmtNickname = cmtNickname;
		
		for(let j=newCmtNickLeng; j > cmtNickMaxLeng; ){
			if(escape(cmtNick).length > 4){
				newCmtNickname = newCmtNickname.substring(0, newCmtNickname.length-1);
				j -= 2;
			} else {
				newCmtNickname = newCmtNickname.substring(0, newCmtNickname.length-1);
				j -= 1;
			}
		}
		$("#cmtNick").val(newCmtNickname);
		
		cmtNickStandard.classList.add(nodisplay);
		cmtNickWarn.classList.remove(nodisplay);
		cmtNickOk.classList.add	(nodisplay);
		
	} else if( cmtNickLeng == 0) {
		/* 입력한 닉네임이 없을 때 */
		cmtNickStandard.classList.add(nodisplay);
		cmtNickWarn.classList.remove(nodisplay);
		cmtNickOk.classList.add(nodisplay);
		
	} else {
		/* 닉네임 길이가 최소길이보다 작을 때 */
		cmtNickStandard.classList.add(nodisplay);
		cmtNickWarn.classList.remove(nodisplay);
		cmtNickOk.classList.add(nodisplay);
	}
	

}

function nickBlurChk(){
	const nickCheck = /[^가-힣a-zA-Z0-9]{1,}/; /* 닉네임 정규식 */
	let nick = document.querySelector("#cmtNick");
	let nickval = nick.value; /* 닉네임 입력받은 값 */
	const standard = document.querySelector("#cmtNickStandard"); /* 초기에 보여줄 아이디 조건 */
	const warn = document.querySelector("#cmtNickWarn"); /* 아이디가 규칙에 부적합하면 보여질 클래스 */
	const ok = document.querySelector("#cmtNickOk"); /* 아이디가 규칙에 부적합하면 보여질 클래스 */
	const nodisplay = 'nodisplay'; /* 아이디가 형식에 적합한지 아닌지를 번갈아 보여주기 위한 class 값 */
	
	const nickMinLength = 2; /* 최소길이 */
	const nickMaxLength = $("#cmtNick").attr('maxlength')*1; /* 최대길이 (한글2자 영문1자이므로 *2) */
	let nickLength = 0; /* 입력받은 닉네임의 길이를 얻기 위해 변수 선언 */
	
	/* 입력 후 blur되면 입력받은 닉네임의 길이를 계산한다 (한글 2자, 영어 및 숫자 1자) */
	for(let i=0; i<nickval.length; i++){
		nick = nickval.charAt(i);
		if(escape(nick).length > 4){
			nickLength += 2;
		} else {
			nickLength += 1;
		}
	}
	
	if( nickval === "" ){
		standard.classList.add(nodisplay);
		ok.classList.add(nodisplay);
		warn.classList.remove(nodisplay);
		
		return false; 
		
	} else {
		if( nickLength < nickMinLength || nickLength > nickMaxLength ){ /* 최소길이와 최대길이 조건 체크 */
			standard.classList.add(nodisplay);
			ok.classList.add(nodisplay);
			warn.classList.remove(nodisplay);
			
			return false;
			
		} else{
			if(nickCheck.test(nickval)){ /* 닉네임 정규식 검사 - 포함되지 않아야 할 값이 있으면 true */
				standard.classList.add(nodisplay);
				ok.classList.add(nodisplay);
				warn.classList.remove(nodisplay);
				
				return false;
				
			} else {
				standard.classList.add(nodisplay);
				warn.classList.add(nodisplay);
				ok.classList.remove(nodisplay);
				
				return true;
			}
		}
	}
	
}

function pwKeyupChk(obj){
	/* 영어와 숫자, 해당 특수문자 외를 알아내는 정규식 */
	const space = /[^A-Za-z0-9#?!@$%^&*-]/;
	
	/* 입력한 길이 구해서 최대길이가 넘기 않는지 확인하기 */
	let oldPw = obj.value;
	let oldPwLeng = oldPw.length;
	let newPw = "";
	const pwMinLeng = 6;
	const pwMaxLeng = $("#cmtPw").attr('maxlength')*1;
	
	const passCheck = /^(?=.*?[A-Za-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{6,}/;
	const standard = document.querySelector("#cmtPwStandard");
	const warn = document.querySelector("#cmtPwWarn");
	const ok = document.querySelector("#cmtPwOk");
	const nodisplay = 'nodisplay';
	
	
	if(space.exec(obj.value)){
		alert("비밀번호에 한글과 공백, 특수문자 (#, ?, !, @, $, %, ^, &, *, - 이외)를 사용할 수 없습니다.");
		obj.focus();
		obj.value = obj.value.replace(/[^A-Za-z0-9#?!@$%^&*-]/g,"");
	}
	

	/* 비밀번호 길이가 유효범위에 들어오면 true 아니면 false */
	if(oldPwLeng >= pwMinLeng || oldPwLeng <= pwMaxLeng){
		/* 유효범위에 들어오므로 비밀번호 유효성 검사를 하여 실시간으로 적합한지 안적합한지 알려준다 */
		if( passCheck.test(oldPw) ){
			standard.classList.add(nodisplay);
			warn.classList.add(nodisplay);
			ok.classList.remove(nodisplay);
			
		} else {
			standard.classList.add(nodisplay);
			ok.classList.add(nodisplay);
			warn.classList.remove(nodisplay);
		}
		
	} else if(oldPwLeng > pwMaxLeng) {
		/* 최대길이보다 길면 최대길이만큼 잘라서 기존 input에 저장 */
		newPw = oldPw.substring(0, pwMaxLeng);
		$("#cmtPw").val(newPw);
		obj.focus();
		
		standard.classList.add(nodisplay);
		ok.classList.add(nodisplay);
		warn.classList.remove(nodisplay);
		
	} else if(oldPwLeng == 0) {
		/* 입력한 비밀번호가 없을 경우 */
		standard.classList.add(nodisplay);
		ok.classList.add(nodisplay);
		warn.classList.remove(nodisplay);

	} else {
		/* 최소길이보다 짧으면 warn을 보여준다 */
		standard.classList.add(nodisplay);
		ok.classList.add(nodisplay);
		warn.classList.remove(nodisplay);
	}
	
}

function pwBlurChk(){
	const passCheck = /^(?=.*?[A-Za-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{6,}/;
	let pass = document.querySelector("#cmtPw");
	let pwVal = pass.value;
	const standard = document.querySelector("#cmtPwStandard");
	const warn = document.querySelector("#cmtPwWarn");
	const ok = document.querySelector("#cmtPwOk");
	const nodisplay = 'nodisplay';
	const pwMinLength = 6;
	const pwMaxLength = $("#cmtPw").attr('maxlength')*1;
	
	if( pwVal.length >= pwMinLength && pwVal.length <= pwMaxLength ){	/* 입력받은 비밀번호의 길이가 최소길이 이상이고, 최대길이 이하일 경우 */
		if( passCheck.test(pwVal) ){	/* 기준이 되는 글자로만 이루어진 경우 true */
			standard.classList.add(nodisplay);
			warn.classList.add(nodisplay);
			ok.classList.remove(nodisplay);
			
			return true;
			
		} else {	/* 기준이 되는 글자 외의 글자가 있을 경우 else */
			standard.classList.add(nodisplay);
			ok.classList.add(nodisplay);
			warn.classList.remove(nodisplay);
			
			return false;
		}
	} else {	/* 입력받은 비밀번호의 길이가 최소길이 미만이거나 최대길이를 초과할 경우 */
		standard.classList.add(nodisplay);
		ok.classList.add(nodisplay);
		warn.classList.remove(nodisplay);
		
		return false;
	}
}

function writeCmt(){
	/* 닉네임 체크 */
	const nickCheck = nickBlurChk();
	
	if(!nickCheck){
		alert("닉네임을 확인해주세요.\n한글 1~10자, 영문 대소문자 및 숫자 2~20자 이내만 사용 가능합니다.\n(혼용 가능)")
		$("#cmtNick").focus();
		
		return false;
	}
	
	/* 비밀번호 체크 */
	const pwCheck = pwBlurChk();
	
	if(!pwCheck){
		alert("비밀번호를 확인해주세요. \n비밀번호는 8 ~ 15자 사이의 영어대소문자/숫자/특수문자로 구성되어야 합니다. (공백 불가)");
		$("#cmtPw").focus();
		
		return false;
	}
	
	const cmtValue = $("#commentContent").val();
	const cmtLength = cmtValue.length;
	const cmtRedex =  /\s/ig;
	
	if(cmtValue.match(/(?<=\s)[가-힣a-zA-Z0-9]/) === null){
		const newCmt = cmtValue.toString().replace(cmtRedex, "").length;
		
		if(newCmt == ""){
			alert("댓글 내용을 입력해주세요.");
			$("#commentContent").focus();
			
			return false;
		}
	}
	
	$.ajax({
		type: "GET"
		, url: "/board/comments/insert"
		, data: {
			boardNo: ${board.boardNo}
			, cNick: $("#cmtNick").val()
			, cPw: $("#cmtPw").val()
			, cComment: $("#commentContent").val()
		}
		, dataType: "html"
		, success: function(res){
			const cmtNickStandard = document.querySelector("#cmtNickStandard");
			const cmtNickWarn = document.querySelector("#cmtNickWarn");
			const cmtNickOk = document.querySelector("#cmtNickOk");
			
			const cmtPwstandard = document.querySelector("#cmtNickStandard");
			const cmtPwwarn = document.querySelector("#cmtNickWarn");
			const cmtPwok = document.querySelector("#cmtNickOk");
			
			const nodisplay = 'nodisplay';
			
			cmtNickStandard.classList.remove(nodisplay);
			cmtNickWarn.classList.add(nodisplay);
			cmtNickOk.classList.add(nodisplay);
			
			cmtPwStandard.classList.remove(nodisplay);
			cmtPwWarn.classList.add(nodisplay);
			cmtPwOk.classList.add(nodisplay);

			$("#cmtList").html(res);
			$("#cmtNick").val('');
			$("#cmtPw").val('');
			$("#commentContent").val('');
		}
		, error: function(res){
			
		}
	})
}

function countText(){
	const redex =  /\s/ig;
	let content = $('#commentContent').val();
	
	if(content.match(/(?<=\s)[가-힣a-zA-Z0-9]/) === null){
		let notIncludeSpace = content.toString().replace(redex, "").length;
		$("#nowStr").text(notIncludeSpace);
	} else {
		let includeSpace = content.length;
		$("#nowStr").text(includeSpace);
	}
}

function updateCmt(c_no, cPw){
	const pwchk = prompt("비밀번호를 입력해주세요.");
	if(pwchk === cPw){
		$.ajax({
			type: "GET"
			, url: "/board/comments/update"
			, data: {
				cNo: c_no
				, boardNo: ${board.boardNo}
			}
			, dataType: "html"
			, success: function(res){
				$("#cmtList").html(res);
			}
			, error: function(res){
				
			}
		})
	} else {
		alert("정확한 비밀번호를 입력해주세요.");
	}
}

function deleteCmt(c_no, cPw){
	const pwchk = prompt("비밀번호를 입력해주세요.");
	if(pwchk === cPw){
		$.ajax({
			type: "GET"
			, url: "/board/comments/delete"
			, data: {
				cNo: c_no
				, boardNo: ${board.boardNo}
			}
			, dataType: "html"
			, success: function(res){
				$("#cmtList").html(res);
			}
			, error: function(res){
				
			}
		})
	} else {
		alert("정확한 비밀번호를 입력해주세요.");
	}
}

function updateCmtFinish(c_no){
	const updateValue = $("#updateComment").val();
	const updateLength = updateValue.length;
	const updateRedex =  /\s/ig;
	
	if(updateValue.match(/(?<=\s)[가-힣a-zA-Z0-9]/) === null){
		const updateCmt = updateValue.toString().replace(updateRedex, "").length;
		
		if(updateCmt == ""){
		alert("내용을 입력해주세요.");
		$("#updateComment").focus();
		
		return false;
		}
	}
	
	$.ajax({
		type: "POST"
		, url: "/board/comments/update"
		, data: {
			cNo: c_no
			, boardNo: ${board.boardNo}
			, cComment: $("#updateComment").val()
		}
		, dataType: "html"
		, success: function(res){
			$("#cmtList").html(res);
		}
		, error: function(res){
			
		}
	})
}

function updateCmtCancel(){
	$.ajax({
		type: "GET"
			, url: "/board/comments/updateCancel"
			, data: {
				boardNo: ${board.boardNo}
			}
			, dataType: "html"
			, success: function(res){
				$("#cmtList").html(res);
			}
			, error: function(res){
				
			}
	})
}

</script>







