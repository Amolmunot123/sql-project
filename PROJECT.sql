use pizzahut_database;

            #BASIC QUESTIONS
            
#Q.1 ).Retrieve the total number of orders placed?
       select count(order_id) from orders ;                    #soln:- 21350
       
#Q.2).Calculate the total revenue generated from pizza sales.
	  select sum(a.price * b.quantity)
      from pizzas as a
      inner join order_details as b
      on a.pizza_id = b.pizza_id 
      group by a.pizza_id ;
      
#Q.3).Identify the highest-priced pizza?
	  select price from pizzas
	  order by price DESC
	  LIMIT 1;                                                  #soln :- 35.95 
      
#Q.4).Identify the most common pizza size ordered.
	 select size from pizzas  
     group by size 
     order by count(pizza_id) DESC
     limit 1;                                                    #soln :- S

#Q.5 ).List the top 5 most ordered pizza types along with their quantities.
	 select pizza_id as most_ordered_pizzatypes 
     from order_details
     group by pizza_id 
     order by sum(quantity) DESC
     limit 5 ;

             #INTERMEDIATE QUESTION
             
#Q.1)Join the necessary tables to find the total quantity of each pizza category ordered.
      select category , sum(quantity) from pizzas 
      inner join order_details 
      on pizzas.pizza_id = order_details.pizza_id
      inner join pizza_types
      on pizza_types.pizza_type_id = pizzas.pizza_type_id
      group by category;
      
#Q.2)Determine the distribution of orders by hour of the day?
	 select avg(total.x) as average_distribution_per_hour
     from 
     (select count(order_id) as x from orders
	 group by hour(order_time)) as total ;
	
#Q.3)Join relevant tables to find the category-wise distribution of pizzas.
     select b.category , count(a.pizza_type_id) from pizzas as a
     inner join pizza_types as b
     on a.pizza_type_id = b.pizza_type_id
     group by b.category;

#Q.4)Group the orders by date and calculate the average number of pizzas ordered per day.
#AVERAGE ORDERS PER DATE:-   
		select  round(avg(b.a)) from
        (select order_date , count(order_id) as a 
		 from orders 
		 group by order_date) as b ;

# orders per date :- 
     select order_date , count(order_id) as a 
	 from orders 
	 group by order_date ;
     
#Q.5).determine the top 3 most ordered pizza types based on revenue.
      select b.pizza_id , round((sum(b.quantity * a.price)) , 1) as revenue
      from pizzas as a
      inner join order_details as b 
      on a.pizza_id = b.pizza_id
      group by b.pizza_id
      order by revenue desc 
      limit 3 ;
      
                     #ADVANCED QUESTION 
                     
#Q.1).Calculate the percentage contribution of each pizza type to total revenue?
     select a.pizza_type_id , 
     (round((((sum(b.quantity * a.price))/ (select sum(b.quantity * a.price) 
											from pizzas as a
											inner join order_details as b 
											 on a.pizza_id = b.pizza_id)) * 100) , 2 )) as percentage_revenue    
      from pizzas as a
      inner join order_details as b 
      on a.pizza_id = b.pizza_id
      group by a.pizza_type_id
      order by percentage_revenue DESC;
                               
#Q.2)Analyze the cumulative revenue generated over time?
     select hour(order_time) ,ROUND(sum(b.quantity * a.price)) from pizzas as a
	 inner join order_details as b 
	  on a.pizza_id = b.pizza_id
      inner join orders 
      on orders.order_id = b.order_id
      group by hour(order_time)
      order by hour(order_time) Asc;
      
#Q.3)Determine the top 3 most ordered pizza types based on revenue for each pizza category?
     (select  b.pizza_id as chicken_pizzas 
      from pizzas as a
      inner join order_details as b 
      on a.pizza_id = b.pizza_id
      inner join pizza_types
      on a.pizza_type_id = pizza_types.pizza_type_id
      group by b.pizza_id ,  category = "chicken"
      order by ROUND(sum(b.quantity * a.price)) desc 
      limit 3)
      union
	  (select  b.pizza_id as veggie_pizzas 
      from pizzas as a
      inner join order_details as b 
      on a.pizza_id = b.pizza_id
      inner join pizza_types  
      on a.pizza_type_id = pizza_types.pizza_type_id
      group by b.pizza_id ,pizza_types.category = "veggie" 
      order by ROUND(sum(b.quantity * a.price)) desc 
      limit 3)
      
      union
     
	  (select  b.pizza_id as classic_pizzas 
      from pizzas as a
      inner join order_details as b 
      on a.pizza_id = b.pizza_id
      inner join pizza_types 
      on a.pizza_type_id = pizza_types.pizza_type_id
      group by b.pizza_id 
      having pizza_types.category = "classic" 
      order by ROUND(sum(b.quantity * a.price)) desc 
      limit 3)
      
      union 
      
	  (select  b.pizza_id as supreme_pizzas 
      from pizzas as a
      inner join order_details as b 
      on a.pizza_id = b.pizza_id
      inner join pizza_types 
      on a.pizza_type_id = pizza_types.pizza_type_id
      group by b.pizza_id 
      having pizza_types.category = "supreme" 
      order by ROUND(sum(b.quantity * a.price)) desc 
      limit 3) ;
	 
      
