<%@ Page Title="Housie - Secure Payment" Language="C#" MasterPageFile="~/customermaster.Master" AutoEventWireup="true" CodeBehind="payment.aspx.cs" Inherits="WebApplication2.payment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .checkout-container {
            max-width: 1120px;
            margin: 40px auto;
            padding: 0 40px;
            color: #222222;
        }

        .checkout-header {
            display: flex;
            align-items: center;
            gap: 20px;
            margin-bottom: 40px;
            padding-bottom: 24px;
            border-bottom: 1px solid #dddddd;
        }
        
        .back-btn {
            background: none; border: none; cursor: pointer;
            font-size: 20px; padding: 10px; border-radius: 50%;
            transition: background 0.2s; text-decoration: none; color: black;
            display: flex; align-items: center; justify-content: center;
        }
        .back-btn:hover { background: #f0f0f0; }

        .checkout-title { font-size: 32px; font-weight: 600; margin: 0; }

        .checkout-split {
            display: flex;
            justify-content: space-between;
            gap: 80px;
        }

        /* LEFT SIDE - PAYMENT FORM */
        .payment-section { flex: 1; max-width: 55%; }
        
        .section-title { font-size: 22px; font-weight: 600; margin-bottom: 24px; }
        
        .trip-details { margin-bottom: 40px; padding-bottom: 30px; border-bottom: 1px solid #dddddd; }
        .detail-row { display: flex; justify-content: space-between; margin-bottom: 16px; }
        .detail-label { font-weight: 600; font-size: 16px; margin-bottom: 4px; }
        .detail-value { font-size: 15px; color: #717171; }

        .payment-box {
            border: 1px solid #b0b0b0;
            border-radius: 12px;
            padding: 24px;
            background: white;
            margin-bottom: 30px;
        }

        .form-group { margin-bottom: 16px; }
        .form-label { display: block; font-size: 14px; font-weight: 600; margin-bottom: 8px; }
        .form-input {
            width: 100%; padding: 12px 16px; border: 1px solid #b0b0b0;
            border-radius: 8px; font-size: 16px; box-sizing: border-box; outline: none;
            background: white; transition: border-color 0.2s;
        }
        .form-input:focus { border-color: #222; border-width: 2px; padding: 11px 15px; }

        .form-row-split { display: flex; gap: 16px; }
        .form-row-split .form-group { flex: 1; }

        /* --- NEW VALIDATION STYLES --- */
        .error-msg {
            color: #E61E4D;
            font-size: 12px;
            font-weight: 500;
            margin-top: 6px;
            display: none; /* Hidden by default */
        }
        .input-error {
            border-color: #E61E4D !important;
            background-color: #fff8f8;
        }

        /* Centered Flexbox Button for Perfect Alignment */
        .pay-btn {
            background: linear-gradient(to right, #E61E4D, #D70466);
            color: white; width: 100%; padding: 16px; border-radius: 8px;
            font-size: 18px; font-weight: 600; border: none; cursor: pointer; 
            transition: filter 0.2s; text-align: center;
            display: flex; justify-content: center; align-items: center;
            box-sizing: border-box; text-decoration: none;
        }
        .pay-btn:hover { filter: brightness(0.95); color: white; }

        /* RIGHT SIDE - ORDER SUMMARY */
        .summary-section { width: 400px; position: sticky; top: 120px; align-self: flex-start; }
        
        .summary-card {
            background: white; border: 1px solid #dddddd; border-radius: 12px;
            padding: 24px; box-shadow: 0 6px 16px rgba(0,0,0,0.12);
        }

        .prop-preview { display: flex; gap: 16px; padding-bottom: 24px; border-bottom: 1px solid #dddddd; margin-bottom: 24px; align-items: center; }
        .prop-img { width: 100px; height: 100px; border-radius: 8px; object-fit: cover; }
        .prop-info { flex: 1; display: flex; flex-direction: column; justify-content: center; }
        .prop-type { font-size: 12px; color: #717171; text-transform: uppercase; font-weight: 600; margin-bottom: 4px; }
        .prop-name { font-size: 16px; font-weight: 600; margin: 0; line-height: 1.3; }

        .price-details-title { font-size: 22px; font-weight: 600; margin-bottom: 20px; }
        
        .price-row { display: flex; justify-content: space-between; font-size: 16px; color: #222; margin-bottom: 16px; }
        .price-row span:first-child { text-decoration: underline; }
        
        .total-row {
            display: flex; justify-content: space-between; font-size: 18px; font-weight: 800;
            padding-top: 24px; border-top: 1px solid #dddddd; margin-top: 8px;
        }

        /* --- SUCCESS POPUP MODAL STYLES --- */
        .modal-overlay {
            display: none; 
            position: fixed; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0, 0, 0, 0.6); z-index: 2000;
            justify-content: center; align-items: center;
            backdrop-filter: blur(4px);
        }
        .modal-box {
            background: white; padding: 40px; border-radius: 16px; width: 90%; max-width: 420px;
            text-align: center; box-shadow: 0 10px 40px rgba(0,0,0,0.2);
            transform: scale(0.9); opacity: 0; transition: all 0.3s ease;
            display: flex; flex-direction: column; align-items: center;
        }
        .modal-overlay.show { display: flex; }
        .modal-overlay.show .modal-box { transform: scale(1); opacity: 1; }
        
        .success-icon { font-size: 70px; color: #00A699; margin-bottom: 20px; } 
        .modal-title { font-size: 26px; font-weight: 800; margin-bottom: 12px; color: #222; }
        .modal-text { font-size: 16px; color: #717171; margin-bottom: 32px; line-height: 1.5; }

        @media (max-width: 900px) {
            .checkout-split { flex-direction: column-reverse; }
            .payment-section { max-width: 100%; }
            .summary-section { width: 100%; position: static; margin-bottom: 40px; }
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <div class="checkout-container">
        
        <div class="checkout-header">
            <a href="javascript:history.back()" class="back-btn"><i class="fas fa-chevron-left"></i></a>
            <h1 class="checkout-title">Request to book</h1>
        </div>

        <div class="checkout-split">
            
            <div class="payment-section">
                
                <h2 class="section-title">Your trip</h2>
                <div class="trip-details">
                    <div class="detail-row">
                        <div>
                            <div class="detail-label">Dates</div>
                            <div class="detail-value"><asp:Label ID="lblDates" runat="server" Text="..."></asp:Label></div>
                        </div>
                    </div>
                    <div class="detail-row">
                        <div>
                            <div class="detail-label">Guests</div>
                            <div class="detail-value"><asp:Label ID="lblGuestCount" runat="server" Text="..."></asp:Label></div>
                        </div>
                    </div>
                </div>

                <h2 class="section-title">Pay with</h2>
                
                <div class="form-group">
                    <asp:DropDownList ID="ddlPaymentMethod" runat="server" CssClass="form-input" style="margin-bottom: 16px;" onchange="togglePaymentMethod()">
                        <asp:ListItem Text="Credit / Debit Card" Value="Card"></asp:ListItem>
                        <asp:ListItem Text="UPI" Value="UPI"></asp:ListItem>
                    </asp:DropDownList>
                </div>

                <%-- CARD DETAILS BOX WITH ERROR MESSAGES --%>
                <div id="card-box" class="payment-box">
                    <div class="form-group">
                        <label class="form-label">Card Number</label>
                        <asp:TextBox ID="txtCardNo" runat="server" CssClass="form-input" placeholder="0000 0000 0000 0000" MaxLength="16"></asp:TextBox>
                        <div id="errCardNo" class="error-msg">Please enter a valid 16-digit card number.</div>
                    </div>
                    <div class="form-row-split">
                        <div class="form-group">
                            <label class="form-label">Expiration</label>
                            <asp:TextBox ID="txtExp" runat="server" CssClass="form-input" placeholder="MM/YY" MaxLength="5"></asp:TextBox>
                            <div id="errExp" class="error-msg">Enter a valid future date (MM/YY).</div>
                        </div>
                        <div class="form-group">
                            <label class="form-label">CVV</label>
                            <asp:TextBox ID="txtCVV" runat="server" CssClass="form-input" placeholder="123" MaxLength="3" TextMode="Password"></asp:TextBox>
                            <div id="errCVV" class="error-msg">CVV must be 3 digits.</div>
                        </div>
                    </div>
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label">Name on Card</label>
                        <asp:TextBox ID="txtName" runat="server" CssClass="form-input" placeholder="John Doe"></asp:TextBox>
                        <div id="errName" class="error-msg">Cardholder name is required.</div>
                    </div>
                </div>

                <%-- UPI DETAILS BOX WITH ERROR MESSAGES --%>
                <div id="upi-box" class="payment-box" style="display: none;">
                    <div class="form-group">
                        <label class="form-label">Enter your UPI ID</label>
                        <asp:TextBox ID="txtUpiId" runat="server" CssClass="form-input" placeholder="username@bank"></asp:TextBox>
                        <div id="errUpiId" class="error-msg">Please enter a valid UPI ID (e.g., name@bank).</div>
                    </div>
                    <div class="form-group" style="margin-bottom: 0;">
                        <label class="form-label">UPI PIN</label>
                        <asp:TextBox ID="txtUpiPin" runat="server" CssClass="form-input" placeholder="******" MaxLength="6" TextMode="Password"></asp:TextBox>
                        <div id="errUpiPin" class="error-msg">UPI PIN must be exactly 6 digits.</div>
                    </div>
                </div>

                <%-- Added OnClientClick to trigger JavaScript validation before postback --%>
                <asp:Button ID="btnPay" runat="server" Text="Confirm and pay" CssClass="pay-btn" OnClientClick="return validatePayment();" OnClick="btnPay_Click" />
            </div>

            <div class="summary-section">
                <div class="summary-card">
                    
                    <div class="prop-preview">
                        <asp:Image ID="imgPropThumb" runat="server" CssClass="prop-img" ImageUrl="https://via.placeholder.com/100" />
                        <div class="prop-info">
                            <div class="prop-type">Entire Home</div>
                            <h3 class="prop-name"><asp:Label ID="lblPropTitle" runat="server" Text="Loading..."></asp:Label></h3>
                        </div>
                    </div>

                    <h3 class="price-details-title">Price details</h3>
                    
                    <div class="price-row">
                        <span>₹<asp:Label ID="lblBasePrice" runat="server" Text="0"></asp:Label> x <asp:Label ID="lblNights" runat="server" Text="0"></asp:Label> nights</span>
                        <span>₹<asp:Label ID="lblBaseTotal" runat="server" Text="0"></asp:Label></span>
                    </div>
                    <div class="price-row">
                        <span>Housie service fee</span>
                        <span>₹<asp:Label ID="lblServiceFee" runat="server" Text="0"></asp:Label></span>
                    </div>
                    
                    <div class="total-row">
                        <span>Total (INR)</span>
                        <span>₹<asp:Label ID="lblGrandTotal" runat="server" Text="0"></asp:Label></span>
                    </div>

                </div>
            </div>

        </div>
    </div>

    <div id="successModal" class="modal-overlay">
        <div class="modal-box">
            <i class="fas fa-check-circle success-icon"></i>
            <div class="modal-title">Payment Successful!</div>
            <div class="modal-text">Your reservation is confirmed. The host has been notified of your upcoming stay.</div>
            <a href="customertrips.aspx" class="pay-btn">Return to Trips</a>
        </div>
    </div>

    <script>
        function togglePaymentMethod() {
            var dropdown = document.getElementById('<%= ddlPaymentMethod.ClientID %>');
            var cardBox = document.getElementById('card-box');
            var upiBox = document.getElementById('upi-box');

            if (dropdown.value === 'UPI') {
                cardBox.style.display = 'none';
                upiBox.style.display = 'block';
            } else {
                cardBox.style.display = 'block';
                upiBox.style.display = 'none';
            }

            // Clear errors when switching tabs
            clearErrors();
        }

        window.onload = function () {
            togglePaymentMethod();
        };

        function showSuccessPopup() {
            document.getElementById('successModal').classList.add('show');
        }

        // --- NEW VALIDATION LOGIC ---
        function clearErrors() {
            // Hide all error messages
            var errorMsgs = document.querySelectorAll('.error-msg');
            errorMsgs.forEach(function (msg) { msg.style.display = 'none'; });

            // Remove red borders from inputs
            var errorInputs = document.querySelectorAll('.input-error');
            errorInputs.forEach(function (input) { input.classList.remove('input-error'); });
        }

        function triggerError(inputId, errorMsgId) {
            document.getElementById(inputId).classList.add('input-error');
            document.getElementById(errorMsgId).style.display = 'block';
        }

        function validatePayment() {
            clearErrors();
            var isValid = true;
            var paymentMethod = document.getElementById('<%= ddlPaymentMethod.ClientID %>').value;

            if (paymentMethod === 'Card') {
                // Validate Card Number (exactly 16 digits)
                var cardNo = document.getElementById('<%= txtCardNo.ClientID %>').value.trim();
                var cardRegex = /^\d{16}$/;
                if (!cardRegex.test(cardNo)) {
                    triggerError('<%= txtCardNo.ClientID %>', 'errCardNo');
                    isValid = false;
                }

                // Validate Expiration (MM/YY format, valid month, year >= current year)
                var exp = document.getElementById('<%= txtExp.ClientID %>').value.trim();
                var expRegex = /^(0[1-9]|1[0-2])\/\d{2}$/; // Allows 01/XX to 12/XX
                if (!expRegex.test(exp)) {
                    triggerError('<%= txtExp.ClientID %>', 'errExp');
                    isValid = false;
                } else {
                    var parts = exp.split('/');
                    var month = parseInt(parts[0], 10);
                    var year = parseInt(parts[1], 10);

                    var today = new Date();
                    var currentMonth = today.getMonth() + 1;
                    var currentYear = parseInt(today.getFullYear().toString().substr(-2), 10); // Gets last 2 digits of current year

                    if (year < currentYear || (year === currentYear && month < currentMonth)) {
                        triggerError('<%= txtExp.ClientID %>', 'errExp');
                        isValid = false;
                    }
                }

                // Validate CVV (exactly 3 digits)
                var cvv = document.getElementById('<%= txtCVV.ClientID %>').value.trim();
                var cvvRegex = /^\d{3}$/;
                if (!cvvRegex.test(cvv)) {
                    triggerError('<%= txtCVV.ClientID %>', 'errCVV');
                    isValid = false;
                }

                // Validate Name (not empty)
                var name = document.getElementById('<%= txtName.ClientID %>').value.trim();
                if (name === "") {
                    triggerError('<%= txtName.ClientID %>', 'errName');
                    isValid = false;
                }

            } else if (paymentMethod === 'UPI') {
                // Validate UPI ID (basic string@string structure)
                var upiId = document.getElementById('<%= txtUpiId.ClientID %>').value.trim();
                var upiRegex = /^[a-zA-Z0-9.\-_]+@[a-zA-Z]+$/;
                if (!upiRegex.test(upiId)) {
                    triggerError('<%= txtUpiId.ClientID %>', 'errUpiId');
                    isValid = false;
                }

                // Validate UPI PIN (exactly 6 digits)
                var upiPin = document.getElementById('<%= txtUpiPin.ClientID %>').value.trim();
                var pinRegex = /^\d{6}$/;
                if (!pinRegex.test(upiPin)) {
                    triggerError('<%= txtUpiPin.ClientID %>', 'errUpiPin');
                    isValid = false;
                }
            }

            // If isValid is false, this prevents the button from submitting to the C# backend
            return isValid;
        }
    </script>
</asp:Content>