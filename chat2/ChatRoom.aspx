<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="ChatRoom.aspx.cs" Inherits="chat2.ChatRoom" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Chat Room</title>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Oxygen', 'Ubuntu', 'Cantarell', sans-serif;
            background: #0a1014;
            height: 100vh;
            overflow: hidden;
        }
        
        .chat-container {
            display: flex;
            height: 100vh;
            width: 100vw;
            background: #111b21;
            overflow: hidden;
        }
        
        .sidebar {
            width: 25%;
            min-width: 260px;
            max-width: 320px;
            background: #202c33;
            border-right: 1px solid #202c33;
            display: flex;
            flex-direction: column;
        }
        
        .documents-panel {
            width: 25%;
            min-width: 260px;
            max-width: 320px;
            background: #202c33;
            border-left: 1px solid #202c33;
            display: flex;
            flex-direction: column;
        }
        
        .sidebar-header {
            padding: 18px 16px;
            background: #202c33;
            color: #e9edef;
            border-right: 1px solid #202c33;
            display: flex;
            flex-direction: column;
            gap: 2px;
        }
        
        .sidebar-header h3 {
            font-size: 17px;
            font-weight: 600;
            margin-bottom: 0;
        }
        
        .sidebar-header p {
            font-size: 12px;
            opacity: 0.7;
        }
        
        .chatrooms-section {
            max-height: 40%;
            overflow-y: auto;
            padding: 8px 0 0 0;
            scrollbar-width: thin;
            scrollbar-color: #374045 #111b21;
            border-bottom: 1px solid rgba(32,44,51,0.9);
        }

        .chatrooms-section::-webkit-scrollbar {
            width: 6px;
        }

        .chatrooms-section::-webkit-scrollbar-track {
            background: #111b21;
            border-radius: 3px;
        }

        .chatrooms-section::-webkit-scrollbar-thumb {
            background: #374045;
            border-radius: 3px;
        }

        .chatrooms-section::-webkit-scrollbar-thumb:hover {
            background: #5a6670;
        }
        
        .documents-section {
            flex: 1;
            overflow-y: auto;
            padding: 8px 0;
            scrollbar-width: thin;
            scrollbar-color: #374045 #111b21;
        }
        
        .documents-section::-webkit-scrollbar {
            width: 6px;
        }
        
        .documents-section::-webkit-scrollbar-track {
            background: #111b21;
            border-radius: 3px;
        }
        
        .documents-section::-webkit-scrollbar-thumb {
            background: #374045;
            border-radius: 3px;
        }
        
        .documents-section::-webkit-scrollbar-thumb:hover {
            background: #5a6670;
        }
        
        .document-date-header {
            padding: 6px 16px 4px 16px;
            margin: 0 8px 2px 8px;
            font-size: 12px;
            font-weight: 500;
            color: #8696a0;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .document-date-header::after {
            content: '\25BE'; /* down-pointing small triangle */
            font-size: 10px;
            color: #8696a0;
        }
        
        .document-item {
            background: #202c33;
            padding: 10px 16px;
            margin: 0 8px 2px 8px;
            cursor: pointer;
            transition: background 0.2s ease;
            display: flex;
            align-items: center;
            gap: 12px;
            border-bottom: 1px solid rgba(134,150,160,0.15);
            border-radius: 0;
        }
        
        .document-item:hover {
            background: #18252f;
        }
        
        .document-icon {
            width: 40px;
            height: 40px;
            background: #202c33;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #8696a0;
            flex-shrink: 0;
            font-size: 18px;
        }
        
        .document-meta {
            flex: 1;
            min-width: 0;
        }
        
        .document-name {
            font-weight: 500;
            margin-bottom: 2px;
            font-size: 14px;
            color: #e9edef;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        
        .document-info {
            font-size: 12px;
            color: #8696a0;
        }
        
        .upload-section {
            padding: 10px 12px;
            border-top: 1px solid #202c33;
            background: #202c33;
        }
        
        .btn-upload {
            width: 100%;
            padding: 10px 12px;
            background: #00a884;
            color: #111b21;
            border: none;
            border-radius: 24px;
            cursor: pointer;
            font-weight: 600;
            font-size: 13px;
            transition: background 0.2s ease, transform 0.1s ease;
        }
        
        .btn-upload:hover {
            background: #06cf9c;
            transform: translateY(-1px);
        }
        
        .btn-upload:active {
            transform: translateY(0);
        }
        
        .main-chat {
            flex: 1;
            display: flex;
            flex-direction: column;
            background: #0b141a;
        }
        
        .chat-header {
            padding: 12px 16px;
            background: #202c33;
            border-left: 1px solid #202c33;
            border-bottom: 1px solid #202c33;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        
        .chat-header h2 {
            font-size: 16px;
            font-weight: 500;
            color: #e9edef;
            margin-bottom: 2px;
        }
        
        .chat-header p {
            font-size: 12px;
            color: #8696a0;
        }
        
        .chat-messages {
            flex: 1;
            padding: 20px 32px 16px 32px;
            overflow-y: auto;
           
            display: flex;
            flex-direction: column;
            gap: 6px;
            scrollbar-width: thin;
            scrollbar-color: rgba(255,255,255,0.2) transparent;
        }
        
        .chat-messages::-webkit-scrollbar {
            width: 8px;
        }
        
        .chat-messages::-webkit-scrollbar-track {
            background: transparent;
        }
        
        .chat-messages::-webkit-scrollbar-thumb {
            background: rgba(255,255,255,0.2);
            border-radius: 4px;
        }
        
        .chat-messages::-webkit-scrollbar-thumb:hover {
            background: rgba(255,255,255,0.3);
        }
        
        .message {
            margin-bottom: 4px;
            display: flex;
        }
        
        .message-content {
            max-width: 60%;
            padding: 6px 8px 4px 9px;
            border-radius: 8px;
            word-wrap: break-word;
            box-shadow: 0 1px 0 rgba(0,0,0,0.25);
            line-height: 1.4;
            font-size: 14px;
        }
        
        .message.sent {
            justify-content: flex-end;
        }
        
        .message.sent .message-content {
            background: #005c4b;
            color: #e9edef;
            border-bottom-right-radius: 0;
        }
        
        .message.received .message-content {
            background: #202c33;
            color: #e9edef;
            border-bottom-left-radius: 0;
        }
        
        .message-info {
            font-size: 11px;
            margin-top: 2px;
            opacity: 0.6;
            padding: 0 2px;
            text-align: right;
        }
        
        .message-sender {
            font-weight: 500;
            margin-bottom: 2px;
            font-size: 12px;
            opacity: 0.8;
        }
        
        .chat-input-area {
            padding: 10px 16px;
            background: #202c33;
            border-top: 1px solid #202c33;
        }
        
        .input-group {
            display: flex;
            gap: 10px;
            align-items: center;
        }
        
        .txt-message {
            flex: 1;
            padding: 9px 12px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-family: inherit;
            transition: background 0.2s ease;
            resize: none;
            max-height: 100px;
            background: #2a3942;
            color: #e9edef;
        }
        
        .txt-message:focus {
            outline: none;
            background: #202c33;
        }
        
        .txt-message::placeholder {
            color: #8696a0;
        }
        
        .read-tick {
            font-size: 11px;
            color: #53bdeb;
            margin-left: 4px;
        }
        
        .btn-attach {
            padding: 9px 10px;
            background: #202c33;
            color: #8696a0;
            border: none;
            border-radius: 50%;
            cursor: pointer;
            font-size: 16px;
            display: flex;
            align-items: center;
            justify-content: center;
            min-width: 40px;
            height: 40px;
            transition: background 0.2s ease, transform 0.1s ease, color 0.2s ease;
        }

        .btn-attach:hover {
            background: #2a3942;
            color: #e9edef;
            transform: translateY(-1px);
        }

        .btn-attach:active {
            transform: translateY(0);
        }

        .btn-send {
            padding: 9px 16px;
            background: #00a884;
            color: #111b21;
            border: none;
            border-radius: 50%;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            transition: background 0.2s ease, transform 0.1s ease;
            display: flex;
            align-items: center;
            justify-content: center;
            min-width: 40px;
            height: 40px;
        }
        
        .btn-send:hover {
            background: #06cf9c;
            transform: translateY(-1px);
        }
        
        .btn-send:active {
            transform: translateY(0);
        }
        
        .btn-logout, .btn-back {
            padding: 6px 10px;
            background: transparent;
            color: #8696a0;
            border: none;
            border-radius: 4px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-weight: 500;
            font-size: 13px;
            transition: background 0.2s ease, color 0.2s ease;
            box-shadow: none;
        }
        
        .btn-logout:hover, .btn-back:hover {
            background: rgba(134,150,160,0.1);
            color: #e9edef;
        }
        
        .btn-back {
            background: transparent;
        }
        
        .btn-back:hover {
            background: rgba(134,150,160,0.1);
        }
        
        .header-buttons {
            display: flex;
            gap: 4px;
        }
        
        .attachment-card {
            display: block;
            border-radius: 8px;
            max-width: 360px;
            overflow: hidden;
            background: rgba(11,20,26,0.9);
            border: 1px solid rgba(134,150,160,0.25);
            box-shadow: 0 1px 0 rgba(0,0,0,0.3);
        }
        
        .attachment-card:hover {
            background: rgba(11,20,26,1);
            border-color: rgba(134,150,160,0.5);
        }
        
        .attachment-link {
            text-decoration: none;
            color: #e9edef;
            display: flex;
            flex-direction: column;
            width: 100%;
        }

        .attachment-preview {
            background: #0b141a;
            padding: 6px 0 4px 0;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .attachment-preview-img {
            display: block;
            width: 100%;
            max-height: 180px;
            object-fit: cover;
            border-radius: 6px;
        }

        .attachment-preview-icon {
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 10px 8px 6px 8px;
        }

        .attachment-type-pill {
            display: none;
            padding: 3px 14px;
            border-radius: 999px;
            background: #f15b5b;
            color: #ffffff;
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 0.03em;
        }

        .attachment-icon {
            width: 56px;
            height: 56px;
            background: #202c33;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #8696a0;
            flex: 0 0 auto;
            font-size: 26px;
        }
        
        .attachment-bottom {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 6px 10px 6px 10px;
        }

        .attachment-bottom-main {
            display: flex;
            align-items: center;
            gap: 8px;
            flex: 1;
            min-width: 0;
        }

        .attachment-doc-icon {
            width: 32px;
            height: 32px;
            border-radius: 16px;
            background: #202c33;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #e9edef;
            font-size: 14px;
            flex: 0 0 auto;
        }

        .attachment-doc-icon-badge {
            background: #f15b5b;
            font-weight: 600;
            font-size: 11px;
        }

        .attachment-meta {
            display: flex;
            flex-direction: column;
            gap: 2px;
            flex: 1;
            min-width: 0;
        }
        
        .attachment-name {
            font-weight: 500;
            font-size: 14px;
            color: #e9edef;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: normal;
            word-wrap: break-word;
        }
        
        .attachment-info {
            font-size: 12px;
            color: #8696a0;
        }
        
        .attachment-actions {
            flex: 0 0 auto;
            display: flex;
            align-items: center;
            color: #8696a0;
        }
        
        .attachment-download-icon {
            font-size: 16px;
        }

        .unread-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 2px 7px;
            margin-left: 6px;
            border-radius: 999px;
            background: #00a884;
            color: #111b21;
            font-size: 11px;
            font-weight: 600;
            letter-spacing: 0.02em;
            white-space: nowrap;
        }

        /* Responsive layout tweaks */
        @media (max-width: 1024px) {
            .chat-messages {
                padding: 16px 16px 12px 16px;
            }
        }

        @media (max-width: 768px) {
            body {
                height: auto;
                overflow: hidden;
            }

            .chat-container {
                flex-direction: row;
                height: 100vh;
                min-height: 100vh;
                overflow-y: hidden;
            }

            .sidebar,
            .documents-panel {
                display: none;
            }

            .main-chat {
                flex: 1;
                width: 100%;
            }

            .chat-header {
                padding: 10px 12px;
            }

            .chat-messages {
                padding: 12px 12px 10px 12px;
            }

            .chat-input-area {
                padding: 8px 10px;
            }

            .sidebar-header {
                padding: 14px 12px;
            }

            .document-item {
                padding: 8px 12px;
            }

            .txt-message {
                font-size: 13px;
            }

            .btn-send,
            .btn-attach {
                min-width: 36px;
                height: 36px;
            }
        }
</style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
        <div class="chat-container">
            <div class="sidebar">
                <div class="sidebar-header">
                    <h3><i class="fas fa-comments"></i> Chats</h3>
                    <p>Select a chat room</p>
                </div>

                <div class="chatrooms-section">
                    <asp:Repeater ID="rptSidebarChatRooms" runat="server">
                        <ItemTemplate>
                            <div class="document-item" onclick='location.href="ChatRoom.aspx?id=<%# Eval("ChatRoomId") %>"'>
                                <div class="document-icon">
                                    <i class="fas fa-comments"></i>
                                </div>
                                <div class="document-meta">
                                    <div class="document-name"><%# Eval("RoomName") %></div>
                                    <div class="document-info">
                                        User: <%# Eval("UserName") %> | Admin: <%# Eval("AdminName") %>
                                        <%# Convert.ToInt32(Eval("UnreadCount")) > 0 
                                            ? "<span class='unread-badge'>" + Eval("UnreadCount") + "</span>" 
                                            : string.Empty %>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                
                <div class="upload-section">
                    <asp:FileUpload ID="fileUpload" runat="server" style="display: none;" />
                    <asp:Button ID="btnUpload" runat="server" Text="📤 Upload Document" CssClass="btn-upload" OnClientClick="document.getElementById('fileUpload').click(); return false;" style="display: none;" />
                    <asp:Button ID="btnUploadServer" runat="server" Text="Submit Upload" style="display: none;" OnClick="btnUploadServer_Click" />
                </div>
            </div>
            
            <div class="main-chat">
                <div class="chat-header">
                    <div>
                        <h2><asp:Label ID="lblRoomName" runat="server"></asp:Label></h2>
                        <p>Chat Room</p>
                    </div>
                    <div class="header-buttons">
                        <asp:HyperLink ID="lnkBack" runat="server" CssClass="btn-back"><i class="fas fa-arrow-left"></i> Back</asp:HyperLink>
                        <asp:Button ID="btnLogout" runat="server" Text="🚪 Logout" CssClass="btn-logout" OnClick="btnLogout_Click" />
                    </div>
                </div>

                <div class="chat-messages" id="messagesContainer">
                    <asp:UpdatePanel ID="updMessages" runat="server" UpdateMode="Conditional">
                        <ContentTemplate>
                            <asp:Repeater ID="rptMessages" runat="server" OnItemDataBound="rptMessages_ItemDataBound">
                                <ItemTemplate>
                                    <div class='message <%# Convert.ToInt32(Eval("SenderId")) == Convert.ToInt32(Session["UserId"]) ? "sent" : "received" %>'>
                                        <div class="message-content">
                                            <%# Convert.ToInt32(Eval("SenderId")) != Convert.ToInt32(Session["UserId"]) ? "<div class='message-sender'>" + Eval("SenderName") + "</div>" : "" %>
                                            <asp:Literal ID="litMessage" runat="server" Mode="PassThrough"></asp:Literal>
                                            <div class="message-info">
                                                <%# Convert.ToDateTime(Eval("SentDate")).ToString("hh:mm tt") %>
                                                <%# Convert.ToInt32(Eval("SenderId")) == Convert.ToInt32(Session["UserId"]) && Convert.ToBoolean(Eval("IsRead"))
                                                    ? "<span class='read-tick'><i class='fas fa-check-double'></i></span>"
                                                    : string.Empty %>
                                            </div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="Timer1" EventName="Tick" />
                            <asp:AsyncPostBackTrigger ControlID="btnSend" EventName="Click" />
                        </Triggers>
                    </asp:UpdatePanel>
                </div>
                
                <div class="chat-input-area">
                    <div class="input-group">
                        <button type="button" class="btn-attach" onclick="document.getElementById('<%= fileUpload.ClientID %>').click();">
                            <i class="fas fa-paperclip"></i>
                        </button>
                        <asp:TextBox ID="txtMessage" runat="server" CssClass="txt-message" placeholder="Type your message..." TextMode="MultiLine" Rows="1"></asp:TextBox>
                        <asp:Button ID="btnSend" runat="server" Text="➤" CssClass="btn-send" OnClick="btnSend_Click" />
                    </div>
                </div>
            </div>
            
            <div class="documents-panel">
                <div class="sidebar-header">
                    <h3><i class="fas fa-file"></i> Documents</h3>
                    <p>Files shared in this chat</p>
                </div>

                <div class="documents-section">
                    <asp:Repeater ID="rptDocuments" runat="server">
                        <ItemTemplate>
                            <%# string.IsNullOrEmpty(Eval("HeaderText") as string) ? string.Empty : "<div class='document-date-header'>" + Eval("HeaderText") + "</div>" %>
                            <div class="document-item" title='<%# Eval("FileName") %>' onclick="downloadDocument(<%# Eval("DocumentId") %>)">
                                <div class="document-icon">
                                    <i class="fas fa-file"></i>
                                </div>
                                <div class="document-meta">
                                    <div class="document-name"><%# Eval("FileName") %></div>
                                    <div class="document-info">
                                        By <%# Eval("UploaderName") %> • <%# Convert.ToDateTime(Eval("UploadDate")).ToString("MMM dd, hh:mm tt") %>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
            </div>
        </div>
        
        <asp:HiddenField ID="hfChatRoomId" runat="server" />
        <asp:HiddenField ID="hfIsScrollAtBottom" runat="server" Value="true" />

        <!-- Hidden fields + button to support adding comments to already-sent documents from chat bubble -->
        <asp:HiddenField ID="hfTagUrl" runat="server" />
        <asp:HiddenField ID="hfTagFileName" runat="server" />
        <asp:HiddenField ID="hfTagComment" runat="server" />
        <asp:Button ID="btnTagDocument" runat="server" Style="display:none;" OnClick="btnTagDocument_Click" />

        <asp:Timer ID="Timer1" runat="server" Interval="1000" OnTick="Timer1_Tick"></asp:Timer>
    </form>

    <script type="text/javascript">
     var isScrollAtBottom = true;
  var messagesContainer = document.getElementById('messagesContainer');

        if (messagesContainer) {
            messagesContainer.addEventListener('scroll', function() {
                var atBottom = (this.scrollHeight - this.scrollTop - this.clientHeight) < 50;
                isScrollAtBottom = atBottom;
                
                var hfScrollState = document.getElementById('<%= hfIsScrollAtBottom.ClientID %>');
                if (hfScrollState) {
                    hfScrollState.value = atBottom ? 'true' : 'false';
                }
            });
        }

        function scrollToBottom() {
            if (messagesContainer) {
                messagesContainer.scrollTop = messagesContainer.scrollHeight;
                isScrollAtBottom = true;
                
                var hfScrollState = document.getElementById('<%= hfIsScrollAtBottom.ClientID %>');
                if (hfScrollState) {
                    hfScrollState.value = 'true';
                }
            }
        }

        function initDocumentAccordion() {
            var headers = document.querySelectorAll('.documents-section .document-date-header');
            headers.forEach(function (header) {
                header.addEventListener('click', function () {
                    var next = header.nextElementSibling;
                    var shouldShow = true;

                    // Decide toggle state based on first document item's visibility
                    while (next && !next.classList.contains('document-date-header')) {
                        if (next.classList.contains('document-item')) {
                            shouldShow = next.style.display === 'none';
                            break;
                        }
                        next = next.nextElementSibling;
                    }

                    next = header.nextElementSibling;
                    while (next && !next.classList.contains('document-date-header')) {
                        if (next.classList.contains('document-item')) {
                            next.style.display = shouldShow ? '' : 'none';
                        }
                        next = next.nextElementSibling;
                    }
                });
            });
        }

        window.onload = function () {
            scrollToBottom();
            initDocumentAccordion();
        };

      var fileUpload = document.getElementById('<%= fileUpload.ClientID %>');
        if (fileUpload) {
            fileUpload.addEventListener('change', function() {
                if (this.files.length > 0) {
                    document.getElementById('<%= btnUploadServer.ClientID %>').click();
                }
            });
        }

        function downloadDocument(docId) {
            window.location.href = 'DownloadDocument.aspx?id=' + docId;
        }

        if (typeof Sys !== 'undefined' && Sys.WebForms && Sys.WebForms.PageRequestManager) {
            var prm = Sys.WebForms.PageRequestManager.getInstance();
            prm.add_endRequest(function () {
                if (isScrollAtBottom) {
                    scrollToBottom();
                }
            });
        }

        // Called from each attachment-card's onclick to link the next Send to that file
        function onAttachmentClicked(card) {
            if (!card) return;

            var link = card.querySelector('.attachment-link');
            if (!link) return;

            var href = link.getAttribute('href') || '';
            var nameEl = card.querySelector('.attachment-name');
            var fileName = nameEl ? nameEl.textContent : '';

            var hfUrl = document.getElementById('<%= hfTagUrl.ClientID %>');
            var hfName = document.getElementById('<%= hfTagFileName.ClientID %>');
            if (!hfUrl || !hfName) return;

            hfUrl.value = href;
            hfName.value = fileName;

            var txt = document.getElementById('<%= txtMessage.ClientID %>');
            if (txt) {
                txt.focus();
            }
        }
    </script>

</body>
</html>