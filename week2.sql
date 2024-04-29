-- Task 1
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `orders_with_quant_more_than2` AS
    SELECT 
        `tb_orders`.`ORDER_ID` AS `ORDER_ID`,
        `tb_orders`.`QUANTITY` AS `QUANTITY`,
        `tb_orders`.`TOTAL_COST` AS `TOTAL_COST`
    FROM
        `tb_orders`
    WHERE
        (`tb_orders`.`QUANTITY` > 2);


-- Task2
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `orders_cost_morethan150` AS
    SELECT 
        `customer`.`CUSTOMER_ID` AS `CUSTOMER_ID`,
        CONCAT(`customer`.`CUSTOMER_NAME`,
                ' ',
                `customer`.`CUSTOMER_SURNAME`) AS `FullName`,
        `orders`.`ORDER_ID` AS `ORDER_ID`,
        `orders`.`TOTAL_COST` AS `TOTAL_COST`,
        `menu`.`MENU_ITEM_NAME` AS `MENU_ITEM_NAME`,
        `mencat`.`CATEGORY_NAME` AS `CATEGORY_NAME`
    FROM
        (((`tb_customer_details` `customer`
        JOIN `tb_orders` `orders` ON ((`orders`.`CUSTOMER_ID` = `customer`.`CUSTOMER_ID`)))
        JOIN `tb_menu` `menu` ON ((`menu`.`MENU_ITEM_ID` = `orders`.`MENU_ITEM_ID`)))
        JOIN `menu_item_categories` `mencat` ON ((`menu`.`MENU_ITEM_ID` = `mencat`.`CATEGORY_ID`)))
    WHERE
        (`orders`.`TOTAL_COST` > 150.00)
    ORDER BY `orders`.`TOTAL_COST`;



-- Task3
CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `orders_morethan2` AS
    SELECT 
        `menu`.`MENU_ITEM_NAME` AS `MENU_ITEM_NAME`
    FROM
        (`tb_orders` `orders`
        JOIN `tb_menu` `menu` ON ((`menu`.`MENU_ITEM_ID` = `orders`.`MENU_ITEM_ID`)))
    WHERE
        `orders`.`QUANTITY` > ANY (SELECT 
                `tb_orders`.`QUANTITY`
            FROM
                `tb_orders`
            WHERE
                (`tb_orders`.`QUANTITY` > 2));
				
-- Task 1  create a procedure that displays the maximum ordered quantity in the Orders table. 
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetMaxQuantity`()
BEGIN
  DECLARE maxQty INT;

SELECT 
    MAX(Quantity)
INTO maxQty FROM
    `LLemonDB`.`tb_orders`;

SELECT maxQty AS 'Maximum Ordered Quantity';
END$$
DELIMITER ;

-- Task 2  prepared statement called GetOrderDetail. 
PREPARE GetOrderDetail FROM 'SELECT Order_ID, Quantity, Total_Cost FROM LLemonDB.tb_Orders WHERE Customer_ID = ?';
SET @id = 1;
EXECUTE GetOrderDetail USING @id;
DEALLOCATE PREPARE GetOrderDetail;

-- Task 3 stored procedure called CancelOrder
DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `Cancel_Order`(IN order_ID_ToDelete INT)
BEGIN
DECLARE orderExistence INT;

  -- Check if the order exists in the database
  SELECT COUNT(*) INTO orderExistence FROM `LLemonDB`.`tb_Orders` WHERE Order_ID = order_ID_ToDelete;

  -- If the order exists, delete it
  IF orderExistence > 0 THEN
    -- First delete related records from OrderDeliveryStatuses table
    DELETE FROM `LLemonDB`.`tb_order_Delivery_Status` WHERE Order_ID = order_ID_ToDelete;

    -- Then delete the order from the Orders table
    DELETE FROM `LLemonDB`.`tb_Orders` WHERE Order_ID = order_ID_ToDelete;

    SELECT CONCAT('Order ', orderIDToDelete, ' is cancelled') AS 'Confirmation';
  ELSE
    SELECT CONCAT('Order ', orderIDToDelete, ' does not exist') AS 'Confirmation';
  END IF;
END$$
DELIMITER ;

-- Exercise: Create SQL queries to add and update bookings
-- Task 1

DELIMITER $$
CREATE PROCEDURE `LLemonDB`.`AddBooking`(
    IN new_booking_id INT, 
    IN new_customer_id INT, 
    IN new_booking_date DATE, 
    IN new_table_number INT
BEGIN
    -- Insert the new booking record
    INSERT INTO `LleLemonDB`.`TB_Bookings`(
        `Booking_ID`, 
        `Customer_ID`, 
        `Date`, 
        `Table_Number`)
    VALUES(
        new_booking_id, 
        new_customer_id, 
        new_table_number
    );

    SELECT 'New booking added' AS 'Confirmation';
END;
//
DELIMITER ;


CALL `LLemonDB`.`AddBooking`(17, 1, '2022-10-10', 5, 2);

-- Task 2

DELIMITER //
CREATE PROCEDURE `LLemonDB`.`UpdateBooking`(
    IN booking_id_to_update INT, 
    IN new_booking_date DATE)
BEGIN
    -- Update the booking record
    UPDATE `LLemonDB`.`TB_Bookings`
    SET `Date` = new_booking_date
    WHERE `BookingID` = booking_id_to_update;

    SELECT CONCAT('Booking ', booking_id_to_update, ' updated') AS 'Confirmation';
END;
//
DELIMITER ;

CALL `LLemonDB`.`UpdateBooking`(9, '2022-11-15');

-- Task 3

DELIMITER //
CREATE PROCEDURE `LLemonDB`.`CancelBooking`(IN booking_id_to_cancel INT)
BEGIN
    -- Delete the booking record
    DELETE FROM `LLemonDB`.`Bookings`
    WHERE `BookingID` = booking_id_to_cancel;

    SELECT CONCAT('Booking ', booking_id_to_cancel, ' cancelled') AS 'Confirmation';
END;
//
DELIMITER ;

CALL `LLemonDB`.`CancelBooking`(9);


