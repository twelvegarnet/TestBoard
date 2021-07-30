<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<c:import url="/WEB-INF/views/layout/header.jsp" />

<div class="content">
	
	<c:if test="${board.parentNo eq 0}">
		<div id="head" style="font-size: 20pt;">게시글 쓰기</div>
	</c:if>
	<c:if test="${board.parentNo ne 0}">
		<div id="head" style="font-size: 20pt;">답글 쓰기</div>
	</c:if>
	<hr>
	
	<form action="/board/write" method="POST" enctype="multipart/form-data">
		<div id="title">
			<label style="width: 32px;">제목</label>
			<input type="text" id="boardTitle" name="boardTitle" placeholder="제목을 입력해주세요."
			style="width: 60%; margin: 0px 0px 10px 48px;" maxlength="50" required onblur="titleChk()"/>
			<label style="">제목은 50자까지 입력가능합니다.</label>
		</div>
		<div id="nickname" style="margin-bottom: 10px; text-align: left;">
			<label>닉네임</label>
			<input type="text" id="boardNick" name="boardNick" style="width: 30%; margin-left: 32px;" placeholder="닉네임" onblur="nickChk()" onkeyup="nickSpaceChk(this)" maxlength="20" required />
			<label id="boardNickStandard">닉네임은 한글 1~10자 혹은 영어, 숫자 2~20자 로 구성되어야 합니다.</label>
			<label id="boardNickWarn" class="nodisplay" style="color: red;">한글 1~10자, 영문, 숫자 2~20자만 사용 가능합니다. (혼용가능)</label>
			<label id="boardNickOk" class="nodisplay" style="color: green;">올바른 형식입니다.</label>
		</div>
		<div id="password" style="margin-bottom: 10px; text-align: left;">
			<label>비밀번호</label>
			<input type="password" id="boardPw" name="boardPw" style="width: 30%; margin-left: 1.6%;" onblur="passChk()" onkeyup="pwSpaceChk(this)" maxlength="10" placeholder="비밀번호" required />
			<i class="fas fa-eye" style="cursor: pointer;"></i>
			<label id="boardPwStandard">비밀번호는 6 ~ 10자 사이의 영어/숫자/특수문자로 구성되어야 합니다.</label>
			<label id="boardPwWarn" class="nodisplay" style="color: red;">비밀번호는 6 ~ 10자 사이의 영어/숫자/특수문자로 구성되어야 합니다.</label>
			<label id="boardPwOk" class="nodisplay" style="color: green;">올바른 형식입니다.</label>
		</div>
		<div id="content">
			<textarea id="boardContent" name="boardContent" placeholder="내용을 입력하세요." 
			style="width: 100%; height: 400px; resize: none; margin-bottom: 10px;" maxlength="4000" onkeyup="countText()" required></textarea>
			<label id="nowStr">0</label>/<label id="limitStr"></label>
		</div><br>
		<div id="fileUploadBtn">
			<input type="button" value="+" onclick="plusInput()" style="margin-bottom: 10px;" />&nbsp;첨부파일 추가
		</div>
		<br>
		<label>※ 이미지 파일( .gif, .jpg, .png, .jpeg )만 업로드 가능합니다.</label><br>
		<label>※ 이미지 업로드는 최대 3MB * 15 개까지 가능합니다.</label>
		<div id="image_container" style="text-align: left;"></div>
		<div id="btnBox" style="text-align: center; margin-top: 30px;">
			<input type="button" value="완료" onclick="submitBtn()" />
			<input type="button" value="취소" onclick="history.go(-1)" />
		</div>
		
		<%-- <input type="hidden" name="layerNo" value="${board.layerNo }" />
		<input type="hidden" name="groupNo" value="${board.groupNo }" /> --%>
		<input type="hidden" name="parentNo" value="${board.parentNo }" />
		<%-- <input type="hidden" name="orderNo" value="${board.orderNo }" /> --%>
	</form>

</div> <%-- content end --%>

<c:import url="/WEB-INF/views/layout/footer.jsp" />

<script type="text/javascript">
$(document).ready(function(){
	$('#password i').on('click',function(){
        $('#boardPw').toggleClass('active');
        if($('#boardPw').hasClass('active')){
            $(this).attr('class',"fas fa-eye-slash")
            .prev('#boardPw').attr('type',"text");
        }else{
            $(this).attr('class',"fas fa-eye")
            .prev('#boardPw').attr('type','password');
        }
    });
});


const textareaLimit = $('textarea').attr('maxlength')*1;
$("#limitStr").text(textareaLimit);


/* 첨부파일에 필요한 데이터를 담기 위한 각 div와 내부 태그들의 id에 부여할 넘버링 */
let fileupBtnNo = 1;

function plusInput(){
	
	/* 파일첨부 버튼, 파일첨부 삭제버튼을 담을 div 생성  */
	const inputArea = document.createElement('div');
	inputArea.setAttribute("id", "fileInputArea"+fileupBtnNo);
	inputArea.setAttribute("class", "fileInputArea");

	/* 다중파일첨부 input 버튼 */
	const input = document.createElement('input');
	input.setAttribute("type", "file");
	input.setAttribute("multiple", "multiple");
	input.setAttribute("id", "fileUploadBtn"+fileupBtnNo);
	input.setAttribute("name", "file");
	input.setAttribute("onchange", "chkUploadFile(event, "+fileupBtnNo+");");
	input.setAttribute("accept", ".gif, .jpg, .png, .jpeg");
	
	/* 해당 파일첨부 input 삭제버튼 */
	const cancel = document.createElement("input");
	cancel.setAttribute("type", "button");
	cancel.setAttribute("id", "deleteBtn"+fileupBtnNo);
	cancel.setAttribute("value", "X");
	cancel.setAttribute("onclick", "deleteInputBtn("+fileupBtnNo+")");
	
	/* 해당 input의 첨부파일 개수를 관리할 input 생성 */
	const eachFileCount = document.createElement("input");
	eachFileCount.setAttribute("type", "hidden");
	eachFileCount.setAttribute("id", "eachFileCount"+fileupBtnNo);
	eachFileCount.setAttribute("value", "0");
	
	/* 첨부된 파일의 이름을 표시할 div 생성 */
	const attachedFileName = document.createElement("div");
	attachedFileName.setAttribute("id", "attachedFileName"+fileupBtnNo);
	attachedFileName.setAttribute("style", "margin-left: 30px; display: inline-block;");
	
	/* plusInput()에서 생성된 inputArea를 담을 위치 */
	const fileUpArea = document.querySelector("#fileUploadBtn");
	
	/* 생성된 div에 다중파일첨부 input 버튼과 input 삭제버튼 삽입 */
	inputArea.append(input);
	inputArea.append(cancel);
	inputArea.append(attachedFileName);
	inputArea.append(eachFileCount);
	
	/* 생성된 div를 기존의 div에 삽입 */
	fileUpArea.append(inputArea);
	
	/* 다음에 생성되는 객체들과 차이를 두기 위해 넘버링값 +1 해주기 */
	fileupBtnNo++;
}





/* 해당 작성글의 총 첨부파일 수 */
let totalFileAmount = 0;

/* 첨부파일 1개당 사이즈 제한 = 3MB */
const fileLimitSize = 3145728;

/* 첨부파일이 이미지 파일인지 체크 */
function chkUploadFile(event, btnNo){
	
	/* -------------------------------- 검사 항목 ------------------------------- */
	
	/* 해당 첨부파일 버튼이 기존에 갖고있던 첨부파일의 수 */
	const originFileCount = $("#eachFileCount"+btnNo).val();
	
	/* 현재 input type="file"에 담겨있는 첨부파일의 수 */
	const nowFileCount = event.target.files.length;
	
	/* 현재 첨부한 파일과 기존에 첨부됐던 파일의 합이 15를 넘는다면  */
	/* 현재 첨부한 파일을 reject한다 */
	if(totalFileAmount-originFileCount+nowFileCount > 15){
		alert("첨부파일은 최대 15개입니다.");
		$("#fileUploadBtn"+btnNo).val("");
		return false;
	}

	/* 첨부파일 타입에 'image'가 들어가는지 체크 */
	const imgChk = /image/;

	/* 모든 첨부파일의 파일 형식, 파일크기 체크 */
	for(var image of event.target.files){
		
		/* n번째 첨부파일이 이미지인지 체크 */
		if(!imgChk.test(image.type)){
			alert("이미지 파일만 첨부가능합니다.");
			$("#fileUploadBtn"+btnNo).val("");
			return false;
		}
		
		/* n번째 첨부파일의 크기가 제한 이내인지 체크 */
		if(image.size > fileLimitSize){
			alert("3MB 이내의 이미지 파일만 첨부 가능합니다.");
			$("#fileUploadBtn"+btnNo).val("");
			return false;
		}
	}

	/* ------------------------------------------------------------------------- */
	
	
	
	/* -------------------------------- 실행 항목 ------------------------------- */
	
	/* 기존에 첨부했던 버튼에 재첨부 시 기존의 첨부파일이 있다면 차감시킨다 */
	if(originFileCount != 0){
	 	totalFileAmount -= originFileCount;
	}
	
	/* 첨부된 파일의 개수만큼 해당 input 버튼의 첨부파일 수 증가시키기 */
	$("#eachFileCount"+btnNo).val(nowFileCount);
	
	/* 첨부된 파일 개수만큼 총 첨부파일 수 증가시키기 */
	totalFileAmount += nowFileCount;
	
	/* 현재 첨부한 전체 첨부파일의 이름 표시하기 */
	let attachedFileList = $("#attachedFileName"+btnNo).val();
	
	for(var image of event.target.files){
		attachedFileList += ("   "+image.name+"    ,");
	}
	
	/* 파일 이름 리스트 마지막의 "," 제거 */
	
		/* 파일 이름 리스트의 전체 길이 */
		let attachedFileListLength = attachedFileList.length;
		
		/* 파일 이름 리스트의 마지막 글자 자르기 */
		attachedFileList = attachedFileList.substring(0, attachedFileListLength-1);
		
	/* 파일 이름 리스트 화면에 출력 */
	$("#attachedFileName"+btnNo).text(attachedFileList);
	
	/* ------------------------------------------------------------------------- */
}






/* 버튼에 해당하는 첨부파일 삭제 */
function deleteInputBtn(btnNo){
	
	/* 해당 버튼의 첨부파일 개수 얻기 */
	const inputArea = document.getElementById("fileInputArea"+btnNo);
	const inputBtn = inputArea.firstChild.files.length;

	/* 총 첨부파일 개수에서 삭제하려는 파일의 개수 차감 */
	totalFileAmount -= inputBtn;
	
	/* 첨부파일에 대한 모든 데이터 삭제를 위해 정보를 담고있는 div 태그 삭제 */
	inputArea.remove();
}







function titleChk(){
	let title = $("#boardTitle");
	let titleval = title.val();
	let titleLength = titleval.length;
	let titleMaxLength = $("#boardTitle").attr('maxlength')*1;
	
	if(titleLength != 0){
		if(titleLength > titleMaxLength){
			return false;
		} else {
			let newText = titleval.substr(0, titleMaxLength);
			title.val(newText);
			
			return true;
		}
	}
}

function nickChk(){
	const nickCheck = /[^가-힣a-zA-Z0-9]{1,}/; /* 닉네임 정규식 */
	let nick = document.querySelector("#boardNick");
	let nickval = nick.value; /* 닉네임 입력받은 값 */
	const standard = document.querySelector("#boardNickStandard"); /* 초기에 보여줄 아이디 조건 */
	const warn = document.querySelector("#boardNickWarn"); /* 아이디가 규칙에 부적합하면 보여질 클래스 */
	const ok = document.querySelector("#boardNickOk"); /* 아이디가 규칙에 부적합하면 보여질 클래스 */
	const nodisplay = 'nodisplay'; /* 아이디가 형식에 적합한지 아닌지를 번갈아 보여주기 위한 class 값 */
	
	const nickMinLength = 2; /* 최소길이 */
	const nickMaxLength = $("#boardNick").attr('maxlength')*1; /* 최대길이 (한글2자 영문1자이므로 *2) */
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

function passChk(){
	const passCheck = /^(?=.*?[A-Za-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{6,}/;
	let pass = document.querySelector("#boardPw");
	let pwVal = pass.value;
	const standard = document.querySelector("#boardPwStandard");
	const warn = document.querySelector("#boardPwWarn");
	const ok = document.querySelector("#boardPwOk");
	const nodisplay = 'nodisplay';
	const pwMinLength = 6;
	const pwMaxLength = $("#boardPw").attr('maxlength')*1;
	
	if( pwVal.length >= pwMinLength || pwVal.length <= pwMaxLength ){	/* 입력받은 비밀번호의 길이가 최소길이 이상이고, 최대길이 이하일 경우 */
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

function nickSpaceChk(obj){
	const space = /\s/;
	const specialChar = /[<>\\/#?!@$%^&*-]/;
	const nickCheck = /[^가-힣a-zA-Z0-9]{1,}/;
	if(space.exec(obj.value) || specialChar.exec(obj.value)){
		alert("닉네임에 공백과 특수문자를 사용할 수 없습니다.");
		obj.focus();
		obj.value = obj.value.replace(/[^가-힣a-zA-Z0-9]/g,"");
	}
	
	/* 입력된 값을 받아서 한글과 영어의 길이를 다르게 계산하고, 계산된 길이가 오버되면 짤라준다 */
	const nickname = obj.value;
	const nickMinLeng = 2;
	const nickMaxLeng = $("#boardNick").attr('maxlength')*1;
	let nickLeng = 0;
	
	const standard = document.querySelector("#boardNickStandard");
	const warn = document.querySelector("#boardNickWarn");
	const ok = document.querySelector("#boardNickOk");
	const nodisplay = 'nodisplay';
	
	for(let i=0; i<nickname.length; i++){
		nick = obj.value.charAt(i);
		if(escape(nick).length > 4){
			nickLeng += 2;
		} else {
			nickLeng += 1;
		}
	}
	
	if(nickLeng >= nickMinLeng && nickLeng <= nickMaxLeng){
		/* 닉네임 길이가 최대길이와 최소길이 범위 내일 때 */
		if(nickCheck.test(nickname)){
			standard.classList.add(nodisplay);
			warn.classList.remove(nodisplay);
			ok.classList.add(nodisplay);
			
		} else {
			standard.classList.add(nodisplay);
			warn.classList.add(nodisplay);
			ok.classList.remove(nodisplay);
		}

	} else if(nickLeng > nickMaxLeng) {
		/* 닉네임 길이가 최대길이보다 클 때 */
		let newNickLeng = nickLeng*1;
		let newNickname = nickname;
		
		for(let j=newNickLeng; j > nickMaxLeng; ){
			if(escape(nick).length > 4){
				newNickname = newNickname.substring(0, newNickname.length-1);
				j -= 2;
			} else {
				newNickname = newNickname.substring(0, newNickname.length-1);
				j -= 1;
			}
		}
		$("#boardNick").val(newNickname);
		
		standard.classList.add(nodisplay);
		warn.classList.remove(nodisplay);
		ok.classList.add	(nodisplay);
		
	} else if( nickLeng == 0) {
		/* 입력한 닉네임이 없을 때 */
		standard.classList.add(nodisplay);
		warn.classList.remove(nodisplay);
		ok.classList.add(nodisplay);
		
	} else {
		/* 닉네임 길이가 최소길이보다 작을 때 */
		standard.classList.add(nodisplay);
		warn.classList.remove(nodisplay);
		ok.classList.add(nodisplay);
	}
	
}

function pwSpaceChk(obj){
	/* 영어와 숫자, 해당 특수문자 외를 알아내는 정규식 */
	const space = /[^A-Za-z0-9#?!@$%^&*-]/;
	
	/* 입력한 길이 구해서 최대길이가 넘기 않는지 확인하기 */
	let oldPw = obj.value;
	let oldPwLeng = oldPw.length;
	let newPw = "";
	const pwMinLeng = 6;
	const pwMaxLeng = $("#boardPw").attr('maxlength')*1;
	
	const passCheck = /^(?=.*?[A-Za-z])(?=.*?[0-9])(?=.*?[#?!@$%^&*-]).{6,}/;
	const standard = document.querySelector("#boardPwStandard");
	const warn = document.querySelector("#boardPwWarn");
	const ok = document.querySelector("#boardPwOk");
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
		$("#boardPw").val(newPw);
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

function countText(){
	const redex =  /\s/ig;
	let content = $('textarea').val();
	
	if(content.match(/(?<=\s)[가-힣a-zA-Z0-9]/) === null){
		let notIncludeSpace = content.toString().replace(redex, "").length;
		$("#nowStr").text(notIncludeSpace);
	} else {
		let includeSpace = content.length;
		$("#nowStr").text(includeSpace);
	}
}

function submitBtn(){
	/* 제목 체크 */
	const titleCheck = titleChk();
	const titleValue = $("#boardTitle").val();
	const titleLength = titleValue.length;
	const redex =  /\s/ig;
	
	if(titleValue.match(/(?<=\s)[가-힣a-zA-Z0-9]/) === null){
		let newTitle = titleValue.toString().replace(redex, "").length;
		
		if(newTitle == ""){
			alert("제목을 입력해주세요");
			$("#boardTitle").focus();
			return false;
		}
	}
	
	
	if(titleLength == 0){
		alert("제목을 입력해주세요.");
		$("#boardTitle").focus();
		
		return false;
	} else {
		if(!titleCheck){
			alert("제목이 너무 깁니다. \n50자 이내로 작성해주세요.");
			$("#boardTitle").focus();
			
			return false;
		}
	}
	
	/* 닉네임 체크 */
	const nickCheck = nickChk();
	
	if(!nickCheck){
		alert("닉네임을 확인해주세요.\n한글 1~10자, 영문 대소문자 및 숫자 2~20자 이내만 사용 가능합니다.\n(혼용 가능)")
		$("#boardNick").focus();
		
		return false;
	}
	
	/* 비밀번호 체크 */
	const pwCheck = passChk();
	
	if(!pwCheck){
		alert("비밀번호를 확인해주세요. \n비밀번호는 8 ~ 15자 사이의 영어대소문자/숫자/특수문자로 구성되어야 합니다. (공백 불가)");
		$("#boardPw").focus();
		
		return false;
	}
	
	const contentValue = $("#boardContent").val();
	const contentLength = contentValue.length;
	const contentRedex =  /\s/ig;
	
	if(contentValue.match(/(?<=\s)[가-힣a-zA-Z0-9]/) === null){
		const newContent = contentValue.toString().replace(contentRedex, "").length;
		
		if(newContent == ""){
		alert("내용을 입력해주세요.");
		$("#boardContent").focus();
		
		return false;
		}
	}
	
	$('form').submit();
}
</script>


