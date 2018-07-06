// 
function JSOC1() {
    window.location.href = "http://www.baidu.com"
    return "88";
}

function JSOC2() {
    window.webkit.messageHandlers.JSMethod.postMessage({title:'测试title',content:'测试content',url:'测试url'});
}

function JSOC3() {
    alert("我原本是 JS-Alert ，通过 Native 代理的实现可以将我转化为 native  弹框");
}

function testDivText(){
    document.getElementById('nativeJSTestID').innerHTML = "已修改";
}

function modifyDivText(divID,nativeText){
    alert(divID);
    document.getElementById(divID).innerHTML = nativeText;
}

function openOtherAPP(){
    //appSDemoB://Detail?para=99web";
    window.location.href = "weixin://";
    //alert(window.navigator.userAgent); https://blog.csdn.net/qq_31411389/article/details/68485700
}
