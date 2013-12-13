<cfinclude template="/includes/_header.cfm">

<link rel="stylesheet" type="text/css" media="screen" href="/includes/jqModal.css"/>
<script src="/includes/jqModal.js" type="text/javascript"></script>

<style type="text/css">
        .jqmOverlay { background-color: #FFF; }
            .jqmWindow {
                background: #888888 url(modal_bckgrn.gif) left top repeat-x;
                color: #000;
                border: 1px solid #888888;
                padding: 0 0px 50px;
            }

            button.jqmClose {
                background: none;
                border: 0px solid #EAEAEB;
                color: #000;
                clear: right;
                float: right;
                padding: 0;
                margin-top:5px;
                margin-left:5px;
                cursor: pointer;
                font-size: 8px;

                letter-spacing: 1px;
            }

            button.jqmClose:hover, button.jqmClose:active {
                color: #FFF;
				border: 0px solid #FFF;
            }

            #jqmTitle {
                background: transparent;
                color: black;
                text-transform: capitalize;
                height: 50px;
                padding: 0px 5px 0 10px;

            }

            #jqmContent {
                width: 100%;
                height: 100%;
                display: block;
                clear: both;
                margin: 0;
                margin-top: 0px;
                background: #e8e8e8;
                border: 1px solid #888888;
            }
        </style>


<script type="text/javascript">
            $(document).ready(function(){
                 //thickbox replacement
    var closeModal = function(hash)
    {
        var $modalWindow = $(hash.w);
        $modalWindow.fadeOut('2000', function()
        {
            hash.o.remove();
            //refresh parent

            if (hash.refreshAfterClose === 'true')
            {

                window.location.href = document.location.href;
            }
        });
    };
    var openInFrame = function(hash)
    {
        var $trigger = $(hash.t);
        var $modalWindow = $(hash.w);
        var $modalContainer = $('iframe', $modalWindow);
        var myUrl = $trigger.attr('href');
        var myTitle = $trigger.attr('title');
        var newWidth = 0, newHeight = 0, newLeft = 0, newTop = 0;
        $modalContainer.html('').attr('src', myUrl);
        $('#jqmTitleText').text(myTitle);
        myUrl = (myUrl.lastIndexOf("#") > -1) ? myUrl.slice(0, myUrl.lastIndexOf("#")) : myUrl;
        var queryString = (myUrl.indexOf("?") > -1) ? myUrl.substr(myUrl.indexOf("?") + 1) : null;

        if (queryString != null && typeof queryString != 'undefined')
        {
            var queryVarsArray = queryString.split("&");
            for (var i = 0; i < queryVarsArray.length; i++)
            {
                if (unescape(queryVarsArray[i].split("=")[0]) == 'width')
                {
                    var newWidth = queryVarsArray[i].split("=")[1];
                }
                if (escape(unescape(queryVarsArray[i].split("=")[0])) == 'height')
                {
                    var newHeight = queryVarsArray[i].split("=")[1];
                }
                if (escape(unescape(queryVarsArray[i].split("=")[0])) == 'jqmRefresh')
                {
                    // if true, launches a "refresh parent window" order after the modal is closed.

                    hash.refreshAfterClose = queryVarsArray[i].split("=")[1]
                } else
                {

                    hash.refreshAfterClose = false;
                }
            }
            // let's run through all possible values: 90%, nothing or a value in pixel
            if (newHeight != 0)
            {
                if (newHeight.indexOf('%') > -1)
                {

                    newHeight = Math.floor(parseInt($(window).height()) * (parseInt(newHeight) / 100));

                }
                var newTop = Math.floor(parseInt($(window).height() - newHeight) / 2);
            }
            else
            {
                newHeight = $modalWindow.height();
            }
            if (newWidth != 0)
            {
                if (newWidth.indexOf('%') > -1)
                {
                    newWidth = Math.floor(parseInt($(window).width() / 100) * parseInt(newWidth));
                }
                var newLeft = Math.floor(parseInt($(window).width() / 2) - parseInt(newWidth) / 2);

            }
            else
            {
                newWidth = $modalWindow.width();
            }

            // do the animation so that the windows stays on center of screen despite resizing
            $modalWindow.css({
                width: newWidth,
                height: newHeight,
                opacity: 0
            }).jqmShow().animate({
                width: newWidth,
                height: newHeight,
                top: newTop,
                left: newLeft,
                marginLeft: 0,
                opacity: 1
            }, 'fast');
        }
        else
        {
            // don't do animations
            $modalWindow.jqmShow();
        }

    }

    $('#modalWindow').jqm({
        overlay: 70,
        modal: true,
        trigger: 'a.thickbox',
        target: '#jqmContent',
        onHide: closeModal,
        onShow: openInFrame
    });

            });
        </script> 
		
		
		
		

<span onclick="jqm();"> jqm() </span>



            Let's see what does <a href="http://search.live.com/results.aspx?q=jqmodal&go=&form=QBLH&width=50%&height=80%&jqmRefresh=true" title="Bill is in da House" class="thickbox">MSN Live</a>
			
			
			
<div id="modalWindow" class="jqmWindow">
        <div id="jqmTitle">
            <button class="jqmClose">
                Close X
            </button>
            <span id="jqmTitleText">Title of modal window</span>
        </div>
        <iframe id="jqmContent" src="">
        </iframe>
    </div>

<cfinclude template="/includes/_footer.cfm">

