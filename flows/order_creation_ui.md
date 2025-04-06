# Order Creation UI Flow

This document describes the user interface flow for creating orders in the WMS system.

## Flow Overview

1. Landing Page → Create Order
2. Product Selection
3. Review Order
4. Order Confirmation

## Detailed Steps

### 1. Landing Page

- User starts at the main landing page
- User selects the "Create Order" option

### 2. Product Selection

- System displays the Product List View
- For each product:
  - User can view product details
  - User can enter quantity
  - User can add product to order using "Add to Order" control
  - If product is already in the order:
    - "Add to Order" control is replaced with "Update Quantity" and "Remove" controls
    - User can modify quantity or remove the product

### 3. Review Order

- System displays a comprehensive order summary:
  - List of selected products
  - Quantity for each product
  - Total price calculation
  - Order metadata (shipping address, customer information, etc.)
- User can:
  - Remove products from the order
  - Edit the order details, including all metadata (customer, shipping address, etc.)
  - Adjust quantities if needed
  - Review all order details
  - Proceed with "Save Order" control

### 4. Order Confirmation

- System makes API call to create the order
- Upon successful creation:
  - User receives confirmation message
  - System redirects to the Orders List view showing all orders including the newly created one
- If the creation fails, the user is notified with an error message

## Related Information

- Order editing is handled by reusing 'Review Order' view. The button is named 'Edit Order' and it is available on the 'Orders List' view.


