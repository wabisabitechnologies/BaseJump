import React from 'react'

class TodoForm extends React.Component {
  constructor(props){
    super(props)
    this.state = {
      title: '',
      assignees: [],
      description: '',
      todo_list_id: this.props.todoList.id,
      author_id: this.props.currentUser.id,
      hasErrors: false,
      hidden: false,
    }
    this.handleSubmit = this.handleSubmit.bind(this)
    this.handleCancel = this.handleCancel.bind(this)
    this.handleErrors = this.handleErrors.bind(this)
    this.update = this.update.bind(this)
    this.toggleHide = this.toggleHide.bind(this)
  }

  handleSubmit(e){
    e.preventDefault()
    this.props.createTodo( this.state ).
    then( res => this.setState( {
      title: '',
      assignees: [],
      description: '',
      todo_list_id: this.props.todoList.id,
      author_id: this.props.currentUser.id,
      hasErrors: false,
    } )).
    catch(res => this.handleErrors(res.responseJSON.errors))
  }

  handleCancel(e){
    e.preventDefault()
    this.setState( {
      title: '',
      assignees: [],
      description: '',
      todo_list_id: this.props.todoList.id,
      author_id: this.props.currentUser.id,
      hasErrors: false,
    } )
    this.toggleHide()
  }

  handleErrors(err){
    this.setState({ hasErrors: true })
  }

  update(field){
    return (e) => {
      this.setState({ hasErrors: false })
      let value = e.target.value
      if( field === 'assignees' ){
        value = value.split(',')
      }
      this.setState({ [field]: value })
    }
  }

  toggleHide(){
    this.setState({ hidden: !this.state.hidden })
  }

  render(){
    const hiddenClass = this.state.hidden ? 'hidden' : ''
    return (
      <div className={`tool-form ${hiddenClass}`} id={`new-todo-${this.props.todoList.id}`}>
        <form>
          <div className='input-fields'>
            <input type='text' id='title' placeholder='Add a new to-do...'
              className={this.state.hasErrors ? 'invalid-input' : ''}
              onChange={this.update('title')} value={this.state.title} />
            <input type='text' placeholder='Assign to...'
              onChange={this.update('assignees')} value={this.state.assignees.join(',')}/>
            <input type='text' placeholder='Add a extra details...'
              onChange={this.update('description')} value={this.state.description} />
          </div>
          <div className='submit-buttons'>
            <input type='submit' value='Add this to-do'
              className='btn btn-submit' onClick={this.handleSubmit}/>
            <input type='submit' value='Cancel'
              className='btn btn-cancel' onClick={this.handleCancel}/>
          </div>
        </form>
      </div>
    )
  }
}

export default TodoForm
