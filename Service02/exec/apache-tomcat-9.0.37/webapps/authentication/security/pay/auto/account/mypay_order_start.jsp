<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<!-- ����� ���� ���� ���� ó�� ������  -->

<%
	request.setCharacterEncoding("UTF-8");
 	//String jsonData2 = "{\"servicetoken\" : \"Efi45N0JO9KQ5my0I2EN97p2a6HBbQ\",\"ci\" : \"4UeU5IS5R1xetNP505FtseuoX485cqAFDQ680da6SuJMRHI4YkuVJcDo4+gtiQu7MWkPHXLLAeo6pGMenzJYcQ==\",\"pcode_idx\" : \"21\",\"sndOrdernumber\" : \"2\",\"sndStoreid\" : \"2999199999\",\"sndGoodname\" :\"���10kg\",\"sndAmount\" : \"1000\",\"sndOrdername\" : \"�׽���\",\"sndCashReceipt\" : \"0\",\"sndRetParam\" : \"A\"}";
%>
<script type="text/javascript">
	function getParamsFromAndroid(jsonData) {
		document.getElementById('userParam').value = jsonData;
		document.forms['Pay_Form'].submit();
	}
	
	<%-- //�׽�Ʈ��
	function getParamsFromAndroid() {
		document.forms['Pay_Form'].submit();
	}
	
	//�׽�Ʈ��
	window.onload = function() {
		document.getElementById('userParam').value = '<%=jsonData2 %>';
		getParamsFromAndroid();		
	} --%>

</script>
<form id='Pay_Form' action="./readyPay.do" method="post" accept-charset="UTF-8">
	<input type="hidden" id="userParam" name="userParam">
</form>