<%@page import="org.apache.logging.log4j.Logger"%>
<%@page import="com.google.gson.JsonObject"%>
<%@page import="com.google.gson.Gson"%>
<%@page import="com.google.gson.JsonParser"%>
<%@page import="com.google.gson.JsonArray"%>
<%@page import="common.properties.PropertiesUtil"%>
<%@page import="orchestrator.orchestrator"%>
<%@ page contentType="text/html;charset=euc-kr" import="java.io.*,java.util.*,java.net.*"
%>
<%
	Logger logger = orchestrator.paylog;

	// get pay data from mobile
	JsonObject jsonData = new Gson().fromJson(request.getAttribute("userParam").toString(), JsonObject.class);
	logger.info(jsonData.toString());

	request.setCharacterEncoding("UTF-8");

	//-----------------------------------------------------------------------
	// ����̵� �߱޵Ǹ� �����Ǵ� ���� , �⺻�� �׽�Ʈ ���̵��.
	String mhkey = PropertiesUtil.getInstance().getString("pay.mhkey");    
	String mekey = PropertiesUtil.getInstance().getString("pay.mekey");       
  	String msalt = PropertiesUtil.getInstance().getString("pay.msalt"); 

  	// ������ �������� �ʴ� �׸�
  	String servicetoken = PropertiesUtil.getInstance().getString("pay.servicetoken");
  	
  	String resultUrl = PropertiesUtil.getInstance().getString("pay.sndReply");
  	String cancelUrl = PropertiesUtil.getInstance().getString("pay.sndCancelUrl");
  	String action = PropertiesUtil.getInstance().getString("pay.action");
  	String sndCharSet     =  PropertiesUtil.getInstance().getString("pay.sndCharSet");
  	String sndThemecolor     =  PropertiesUtil.getInstance().getString("pay.sndThemecolor");
  	
  	String sndOrdernumber =  jsonData.get("sndOrdernumber").getAsString();
  	String sndStoreid     =  PropertiesUtil.getInstance().getString("pay.sndStoreid");
  	String sndCashReceipt =  jsonData.get("sndCashReceipt").getAsString();
  	
	// ������ �������� �׸�
  	String sndGoodname    = jsonData.get("sndGoodname").getAsString();
  	String sndAmount      = jsonData.get("sndAmount").getAsString();
  	String sndOrdername   = jsonData.get("sndOrdername").getAsString();
  	String sndEmail       = jsonData.get("sndEmail").getAsString();
  	String sndRetParam    = jsonData.get("sndRetParam").getAsString();
  	
	// CI��û ������ ��ȣȭ ������ 
  	String ci           = jsonData.get("ci").getAsString() ;   		//CI
  	String birthdate    = jsonData.get("birthdate").getAsString();    //�������(YYYYMMDD)
  	String gender       = jsonData.get("gender").getAsString();    // �������� ( �ֹι�ȣ��1�ڸ�)
  	String mobile       = jsonData.get("mobile").getAsString();    // �޴���ȭ��ȣ.
	// ----------------------------------------------------------------------
	
	String curr_date_14 = new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date());
	String etoken = ksnet.kspay.MypayHostBean.get_etoken(mhkey, curr_date_14,"");
	
	StringBuffer sb = new StringBuffer();
	sb.append(curr_date_14   ).append(':');
	sb.append("servicetoken").append('=').append(servicetoken ).append('&');
	sb.append("ci").append('=').append(ci ).append('&');
	sb.append("birthdate").append('=').append(birthdate ).append('&');
	sb.append("gender").append('=').append(gender ).append('&');
	sb.append("mobile").append('=').append(mobile      ) ;
	
	String p_data = sb.toString();

	String edata = ksnet.kspay.MypayHostBean.encrypt_msg(mekey ,p_data);  // ������ ��ȣȭ.
	
	System.out.println();
	
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0" />
</head>
<script language="javascript">
	function _pay(_frm) 
	{
		_frm.sndReply.value=getLocalUrl('<%=resultUrl %>');
		_frm.sndCancelUrl.value=getLocalUrl('<%=cancelUrl %>');
		_frm.action ='<%=action %>';  // � : https://kspay.ksnet.to/store/MYPay/MYPayWeb.jsp , ���� : http://210.181.28.134/store/MYPay/MYPayWeb.jsp
		_frm.submit();
	}
	function getLocalUrl(mypage) 
	{ 
		var myloc = location.href; 
		return myloc.substring(0, myloc.lastIndexOf('/')) + '/' + mypage;
	} 
	
 	window.onload = function() {
		_pay(document.KSPayWeb);
	}
</script>
<body>
<!-----------------------------------------<Part 1. KSPayWeb Form: ������û �Ķ���� ����. > ---------------------------------->
<form name="KSPayWeb" method="post" target="_self">
	<input type="hidden" name="sndMsalt" size=30  value="<%=msalt%>">
	<input type="hidden" name="sndEdata" size=30  value="<%=edata%>">
	<input type="hidden" name="sndEtoken" size=30  value="<%=etoken%>">
	<input type="hidden" name="sndOrdernumber" size=30  value="<%=sndOrdernumber%>">
	<input type="hidden" name="sndStoreid" size=30  value="<%=sndStoreid%>">
	<!-- ������ �����ִ� �׸� -->
	<input type="hidden" name="sndGoodname" size=30  value="<%=sndGoodname%>">
	<input type="hidden" name="sndAmount" size=30  value="<%=sndAmount%>">
	<input type="hidden" name="sndOrdername" size=30  value="<%=sndOrdername%>">
	<input type="hidden" name="sndCashReceipt" size=30  value="<%=sndCashReceipt%>">
	<input type="hidden" name="sndEmail" size=30  value="<%=sndEmail%>">
	
	<input type=hidden name="sndReply"      value="" >
	<input type=hidden name="sndCancelUrl"  value="" >
	<input type=hidden name="sndRetParam"   value="<%=sndRetParam %>"> <!-- sndReply , sndCancelUrl �� ���޵Ǿ���ϴ� �Ķ���� Ư������ ' " - ` �� ����ϽǼ� �����ϴ�. (����ǥ,�ֵ���ǥ,����,�������̼�)  -->
	<input type=hidden name="sndCharSet"    value="<%=sndCharSet %>">         <!-- defalut : EUC-KR -->
	<input type=hidden name="sndThemecolor"    value="<%=sndThemecolor %>">         <!-- defalut : EUC-KR -->
</form>
</body>
</html>
