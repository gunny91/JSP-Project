//------------------------------------------------------------------
// 책 등록 항목 검사
//------------------------------------------------------------------
function checkForm(writeform)
{
	//jquery 로 사용할 때 방법
	//if(!$("#book_kind option:selected").val()) <= id값으로 비교할 때
	//if(!$("select[name=book_kind]").val()) <= name값으로 비교할 때
	
	if(!writeform.book_kind.value) {
		alert("책의 분류를 선택하십시오.");
		writeform.book_kind.focus();
		return false;
	} 
	if(!writeform.book_title.value) {
		alert("책의 제목을 입력하십시오.");
		writeform.book_title.focus();
		return false;
	}
	if(!writeform.book_price.value) {
		alert("책의 가격을 입력하십시오.");
		writeform.book_price.focus();
		return false;
	}
	if(!writeform.book_count.value) {
		alert("책의 수량을 입력하십시오.");
		writeform.book_count.focus();
		return false;
	}
	if(!writeform.author.value) {
		alert("책의 저자를 입력하십시오.");
		writeform.author.focus();
		return false;
	}
	if(!writeform.publishing_com.value) {
		alert("출판사 이름을 입력하십시오.");
		writeform.publishing_com.focus();
		return false;
	}
	if(!writeform.book_content.value) {
		alert("책의 내용을 입력하십시오.");
		writeform.book_content.focus();
		return false;
	}
	if(!writeform.discount_rate.value) {
		alert("책의 할인율을 입력하십시오.");
		writeform.discount_rate.focus();
		return false;
	}
	writeform.action = "bookRegisterPro.jsp";
	writeform.submit();
	
}
// 책의 정보를 수정한다.
function bookUpdateCheckForm(updateform) 
{ 
	if(!updateform.book_kind.value) {
		alert("책의 분류를 선택하십시오.");
		updateform.book_kind.focus();
		return false;
	}
	if(!updateform.book_title.value) {
		alert("책의 제목을 입력하십시오.");
		updateform.book_title.focus();
		return false;
	}
	if(!updateform.book_price.value) {
		alert("책의 가격을 입력하십시오.");
		updateform.book_price.focus();
		return false;
	}
	if(!updateform.book_count.value) {
		alert("책의 수량을 입력하십시오.");
		updateform.book_count.focus();
		return false;
	}
	if(!updateform.author.value) {
		alert("책의 저자를 입력하십시오.");
		updateform.author.focus();
		return false;
	}
	if(!updateform.publishing_com.value) {
		alert("출판사를 입력하십시오.");
		updateform.publishing_com.focus();
		return false;
	}
	if(!updateform.book_content.value) {
		alert("책의 내용을 입력하십시오.");
		updateform.book_cotent.focus();
		return false;
	}
	if(!updateform.discount_rate.value) {
		alert("책의 할인율을 입력하십시오.");
		updateform.discount_rate.focus();
		return false;
	}

	updateform.action = "bookUpdatePro.jsp";
	updateform.submit();

}








