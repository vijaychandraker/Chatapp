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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            height: 100vh;
            overflow: hidden;
        }
        
        .chat-container {
            display: flex;
            height: 100vh;
            background: white;
        }
        
        .sidebar {
            width: 320px;
            background: linear-gradient(180deg, #ffffff 0%, #f8f9fa 100%);
            border-right: 1px solid #e8eaf6;
            display: flex;
            flex-direction: column;
            box-shadow: 2px 0 8px rgba(0,0,0,0.05);
        }
        
        .sidebar-header {
            padding: 24px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 0 0 16px 0;
        }
        
        .sidebar-header h3 {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 4px;
        }
        
        .sidebar-header p {
            font-size: 13px;
            opacity: 0.9;
        }
        
        .documents-section {
            flex: 1;
            overflow-y: auto;
            padding: 16px;
            scrollbar-width: thin;
            scrollbar-color: #ddd #f5f5f5;
        }
        
        .documents-section::-webkit-scrollbar {
            width: 6px;
        }
        
        .documents-section::-webkit-scrollbar-track {
            background: #f5f5f5;
            border-radius: 3px;
        }
        
        .documents-section::-webkit-scrollbar-thumb {
            background: #ddd;
            border-radius: 3px;
        }
        
        .documents-section::-webkit-scrollbar-thumb:hover {
            background: #bbb;
        }
        
        .document-item {
            background: white;
            padding: 14px;
            margin-bottom: 12px;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 12px;
            border: 1px solid #e8eaf6;
            box-shadow: 0 2px 4px rgba(0,0,0,0.02);
        }
        
        .document-item:hover {
            background: #f8f9fa;
            border-color: #667eea;
            transform: translateX(4px);
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.15);
        }
        
        .document-icon {
            width: 40px;
            height: 40px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            flex-shrink: 0;
            font-size: 18px;
        }
        
        .document-meta {
            flex: 1;
            min-width: 0;
        }
        
        .document-name {
            font-weight: 600;
            margin-bottom: 4px;
            font-size: 13px;
            color: #1a1a1a;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        
        .document-info {
            font-size: 11px;
            color: #999;
        }
        
        .upload-section {
            padding: 16px;
            border-top: 1px solid #e8eaf6;
            background: #f8f9fa;
            border-radius: 0 0 0 16px;
        }
        
        .btn-upload {
            width: 100%;
            padding: 12px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
        }
        
        .btn-upload:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }
        
        .btn-upload:active {
            transform: translateY(0);
        }
        
        .main-chat {
            flex: 1;
            display: flex;
            flex-direction: column;
            background: #ffffff;
        }
        
        .chat-header {
            padding: 20px 32px;
            background: white;
            border-bottom: 1px solid #e8eaf6;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 8px rgba(0,0,0,0.02);
        }
        
        .chat-header h2 {
            font-size: 22px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 4px;
        }
        
        .chat-header p {
            font-size: 13px;
            color: #999;
        }
        
        .chat-messages {
            flex: 1;
            padding: 28px 32px;
            overflow-y: auto;
            background: linear-gradient(180deg, #ffffff 0%, #f8f9fa 100%);
            display: flex;
            flex-direction: column;
            gap: 12px;
            scrollbar-width: thin;
            scrollbar-color: #ddd white;
        }
        
        .chat-messages::-webkit-scrollbar {
            width: 8px;
        }
        
        .chat-messages::-webkit-scrollbar-track {
            background: white;
        }
        
        .chat-messages::-webkit-scrollbar-thumb {
            background: #ddd;
            border-radius: 4px;
        }
        
        .chat-messages::-webkit-scrollbar-thumb:hover {
            background: #bbb;
        }
        
        .message {
            margin-bottom: 8px;
            display: flex;
            animation: slideIn 0.3s ease;
        }
        
        @keyframes slideIn {
            from {
                opacity: 0;
                transform: translateY(10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        .message-content {
            max-width: 55%;
            padding: 12px 18px;
            border-radius: 16px;
            word-wrap: break-word;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            line-height: 1.4;
        }
        
        .message.sent {
            justify-content: flex-end;
        }
        
        .message.sent .message-content {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-bottom-right-radius: 4px;
        }
        
        .message.received .message-content {
            background: #f0f2f5;
            color: #1a1a1a;
            border-bottom-left-radius: 4px;
        }
        
        .message-info {
            font-size: 11px;
            margin-top: 6px;
            opacity: 0.6;
            padding: 0 8px;
        }
        
        .message-sender {
            font-weight: 700;
            margin-bottom: 6px;
            font-size: 12px;
            opacity: 0.8;
        }
        
        .chat-input-area {
            padding: 20px 32px;
            background: white;
            border-top: 1px solid #e8eaf6;
        }
        
        .input-group {
            display: flex;
            gap: 12px;
            align-items: center;
        }
        
        .txt-message {
            flex: 1;
            padding: 14px 20px;
            border: 2px solid #e8eaf6;
            border-radius: 24px;
            font-size: 14px;
            font-family: inherit;
            transition: all 0.3s ease;
            resize: none;
            max-height: 100px;
        }
        
        .txt-message:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
            background: #fafbfc;
        }
        
        .txt-message::placeholder {
            color: #ccc;
        }
        
        .btn-send {
            padding: 12px 28px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 24px;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            transition: all 0.3s ease;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .btn-send:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
        }
        
        .btn-send:active {
            transform: translateY(0);
        }
        
        .btn-logout, .btn-back {
            padding: 10px 20px;
            background: #f44336;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-weight: 600;
            font-size: 13px;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(244, 67, 54, 0.2);
        }
        
        .btn-logout:hover, .btn-back:hover {
            background: #d32f2f;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(244, 67, 54, 0.3);
        }
        
        .btn-back {
            background: #757575;
            box-shadow: 0 2px 8px rgba(117, 117, 117, 0.2);
        }
        
        .btn-back:hover {
            background: #616161;
            box-shadow: 0 4px 12px rgba(117, 117, 117, 0.3);
        }
        
        .header-buttons {
            display: flex;
            gap: 12px;
        }
        
        .attachment-card {
            display: flex;
            align-items: center;
            gap: 12px;
            border: 1px solid #e8eaf6;
            background: white;
            padding: 12px;
            border-radius: 12px;
            max-width: 420px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
            transition: all 0.3s ease;
        }
        
        .attachment-card:hover {
            border-color: #667eea;
            box-shadow: 0 4px 12px rgba(102, 126, 234, 0.15);
        }
        
        .attachment-link {
            text-decoration: none;
            color: inherit;
            display: flex;
            gap: 12px;
            align-items: center;
            width: 100%;
        }
        
        .attachment-thumb {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 8px;
            flex: 0 0 auto;
        }
        
        .attachment-icon {
            width: 50px;
            height: 50px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            flex: 0 0 auto;
            font-size: 24px;
        }
        
        .attachment-meta {
            display: flex;
            flex-direction: column;
            gap: 4px;
            flex: 1;
            min-width: 0;
        }
        
        .attachment-name {
            font-weight: 600;
            font-size: 13px;
            color: #1a1a1a;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }
        
        .attachment-info {
            font-size: 11px;
            color: #999;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
        <div class="chat-container">
            <div class="sidebar">
                <div class="sidebar-header">
                    <h3><i class="fas fa-file-alt"></i> Documents</h3>
                    <p>Shared files in this chat</p>
                </div>
                
                <div class="documents-section">
                    <asp:Repeater ID="rptDocuments" runat="server">
                        <ItemTemplate>
                            <div class="document-item" title='<%# Eval("FileName") %>'>
                                <div class="document-icon">
                                    <i class="fas fa-file"></i>
                                </div>
                                <div class="document-meta">
                                    <div class="document-name"><%# Eval("FileName") %></div>
                                    <div class="document-info">
                                        By <%# Eval("UploaderName") %> • <%# Convert.ToDateTime(Eval("UploadDate")).ToString("MMM dd") %>
                                    </div>
                                </div>
                            </div>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>
                
                <div class="upload-section">
                    <asp:FileUpload ID="fileUpload" runat="server" style="display: none;" />
                    <asp:Button ID="btnUpload" runat="server" Text="📤 Upload Document" CssClass="btn-upload" OnClientClick="document.getElementById('fileUpload').click(); return false;" />
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
                                            <div class="message-info"><%# Convert.ToDateTime(Eval("SentDate")).ToString("hh:mm tt") %></div>
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="Timer1" EventName="Tick" />
                        </Triggers>
                    </asp:UpdatePanel>
                </div>
                
                <div class="chat-input-area">
                    <div class="input-group">
                        <asp:TextBox ID="txtMessage" runat="server" CssClass="txt-message" placeholder="Type your message..." TextMode="MultiLine" Rows="1"></asp:TextBox>
                        <asp:Button ID="btnSend" runat="server" Text="Send" CssClass="btn-send" OnClick="btnSend_Click" />
                    </div>
                </div>
            </div>
        </div>
        
        <asp:HiddenField ID="hfChatRoomId" runat="server" />
        <asp:HiddenField ID="hfIsScrollAtBottom" runat="server" Value="true" />
        <asp:Timer ID="Timer1" runat="server" Interval="3000" OnTick="Timer1_Tick"></asp:Timer>
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

        window.onload = function () {
            scrollToBottom();
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
    </script>
</body>
</html>