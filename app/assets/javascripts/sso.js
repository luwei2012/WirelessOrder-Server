//var rootURL= "http://youya.xd.dyns.cx:8001"
var validateRoot = "http://" + document.location.host;


function loginOnClick() {
    document.getElementById("loading").style.display = "";
    var username = $("input[name='username']").val();
    var password = $("input[name='password']").val();
    var url = validateRoot+'/welcome';
    var form = $('<form action="' + url + '" method="post">' +
        '<input type="hidden" name="username" value="' + username + '" />' +
        '<input type="hidden" name="password" value="' + password + '" />' +
        '</form>');
    $('body').append(form);
    $(form).submit();
}
