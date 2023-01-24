$(document).on('NopOnePageCheckoutPaymentMethodsRefreshedEvent', function () {

    var dataElement = $('#paypalSmartPaymentButtonsData');

    if (dataElement.length === 0) {

        return;
    }

    var paymentForm = paypal.Buttons({
        style: {
            layout: dataElement.attr('data-layout'),
            color: dataElement.attr('data-color'),
            shape: dataElement.attr('data-shape'),
            label: dataElement.attr('data-label'),
            tagline: dataElement.attr('data-tagline')
        },

        createOrder: function (data, actions) {
            return dataElement.attr('data-orderId');
        },

        onApprove: function (data, actions) {
            $('.confirm-button button').trigger("click");
        },

        onError: function (err) {
            $(dataElement.attr('data-errorsSelector')).val(err);
            paymentForm = null;
            $('.confirm-button button').trigger("click");
        }
    });
    if (paymentForm) {
        paymentForm.render('#paypal-button-container');
    }

    $(document).on('accordion_section_opened', function (data) {
        if (data.currentSectionId != 'opc-payment_info') {
            $('.payment-info-next-step-button').show();
        }
    });
});