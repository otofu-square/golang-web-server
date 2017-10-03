package main

import (
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
)

func CreateTodo(c *gin.Context) {
	completed, _ := strconv.Atoi(c.PostForm("completed"))
	todo := Todo{Title: c.PostForm("title"), Completed: completed}
	db := Database()
	db.Save(&todo)
	c.JSON(http.StatusCreated, gin.H{
		"status":     http.StatusCreated,
		"message":    "Todo item created successfully!",
		"resourceId": todo.ID,
	})
}

func main() {
	db := Database()
	db.AutoMigrate(&Todo{})

	r := gin.Default()
	v1 := r.Group("/api/v1/todos")
	{
		v1.POST("/", CreateTodo)
		// v1.GET("/", FetchAllTodo)
		// v1.GET("/:id", FetchSingleTodo)
		// v1.PUT("/:id", UpdateTodo)
		// v1.DELETE("/:id", DeleteTodo)
	}
	r.Run()
}
