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

func FetchAllTodo(c *gin.Context) {
	var todos []Todo
	var _todos []TransformedTodo

	db := Database()
	db.Find(&todos)

	if len(todos) <= 0 {
		c.JSON(http.StatusNotFound, gin.H{
			"status":  http.StatusNotFound,
			"message": "No todo found!",
		})
		return
	}

	for _, item := range todos {
		completed := false
		if item.Completed == 1 {
			completed = true
		}
		_todos = append(_todos, TransformedTodo{ID: item.ID, Title: item.Title, Completed: completed})
	}
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "data": _todos})
}

func FetchSingleTodo(c *gin.Context) {
	var todo Todo
	todoID := c.Param("id")

	db := Database()
	db.First(&todo, todoID)

	if todo.ID == 0 {
		c.JSON(http.StatusNotFound, gin.H{"status": http.StatusNotFound, "message": "No todo found!"})
		return
	}

	completed := false
	if todo.Completed == 1 {
		completed = true
	}
	_todo := TransformedTodo{ID: todo.ID, Title: todo.Title, Completed: completed}
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "data": _todo})
}

func UpdateTodo(c *gin.Context) {
	var todo Todo
	todoID := c.Param("id")

	db := Database()
	db.First(&todo, todoID)

	if todo.ID == 0 {
		c.JSON(http.StatusNotFound, gin.H{"status": http.StatusNotFound, "message": "No todo found!"})
		return
	}

	db.Model(&todo).Update("title", c.PostForm("title"))
	completed, _ := strconv.Atoi(c.PostForm("completed"))
	db.Model(&todo).Update("completed", completed)
	c.JSON(http.StatusOK, gin.H{"status": http.StatusOK, "message": "Todo updated successfully!"})
}

func main() {
	db := Database()
	db.AutoMigrate(&Todo{})

	r := gin.Default()
	v1 := r.Group("/api/v1/todos")
	{
		v1.POST("/", CreateTodo)
		v1.GET("/", FetchAllTodo)
		v1.GET("/:id", FetchSingleTodo)
		v1.PUT("/:id", UpdateTodo)
		// v1.DELETE("/:id", DeleteTodo)
	}
	r.Run()
}
