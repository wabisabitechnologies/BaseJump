import React from 'react'
import ProjectCard from './project_card'
import { Link } from 'react-router-dom'
import Dropdown, { DropdownTrigger, DropdownContent } from 'react-simple-dropdown'
import Loading from './loader'

class ProjectSection extends React.Component {
  constructor(props) {
    super(props)
    this.state = {
      submittedProject: false,
      loading: false,
      project: {name: '', project_type: '', admin_id: ''},
      hasErrors: false,
    }
    this.dividerText = this.dividerText.bind(this)
    this.companyLogo = this.companyLogo.bind(this)
    this.userLinks = this.userLinks.bind(this)
    this.newProjectButton = this.newProjectButton.bind(this)
    this.update = this.update.bind(this)
    this.handleSubmit = this.handleSubmit.bind(this)
    this.handleCancel = this.handleCancel.bind(this)
    this.dropdownRef = React.createRef()
  }

  componentDidMount(){
    const project = {
      name: '',
      project_type: this.props.projectType,
      admin_id: this.props.currentUser.id
    }
    this.setState( { project })
  }

  componentWillReceiveProps(newProps){
    if (newProps.submittedProject){
      this.setState({
        project: {name: '', project_type: newProps.projectType, admin_id: this.props.currentUser.id},
        submittedProject: false
      })
    }
  }

  dividerText(){
    const projectType = this.props.projectType
    switch(projectType){
      case 'team':
        return 'Teams'
      case 'company':
        return 'Company HQ'
      default:
        return 'Projects'
    }
  }

  companyLogo(){
    if(this.props.projectType === 'company'){
      return (
        <li className='card-company-logo'>
          <img src='https://res.cloudinary.com/basejump/image/upload/v1580630789/basecamp-logo-mini.png'/>
          <h1>BaseJump</h1>
        </li>
      )
    }
  }

  userLinks(){
    if(this.props.projectType === 'company'){
      return (
        <div>
          <Link to='/'>My Assignments</Link>
          <Link to='/'>Bookmarks</Link>
          <Link to='/'>Schedule</Link>
          <Link to='/'>Drafts</Link>
          <Link to='/'>Recent Activity</Link>
        </div>
      )
    }
  }

  newProjectButton(){
    const projectType = this.props.projectType
    if(projectType !== 'company'){
      return (
        <Dropdown ref={this.dropdownRef}>
          <DropdownTrigger className='btn btn-new'>
            New
          </DropdownTrigger>
          <DropdownContent>
            <form className='new-project-dropdown'>
              <input type='text' id={projectType}
                className={this.state.hasErrors ? 'invalid-input' : ''}
                placeholder={`${projectType[0].toUpperCase() + projectType.slice(1)} Name`}
                value={this.state.project.name} onChange={this.update}/>
              <div>
                <input type='submit' value='Save' className='btn btn-submit'
                  onClick={this.handleSubmit} />
                <input type='submit' value='Cancel' className='btn btn-cancel'
                  onClick={this.handleCancel}/>
              </div>
            </form>
          </DropdownContent>
        </Dropdown>
      )
    }
  }

  update(e) {
    this.setState({ hasErrors: false })
    e.preventDefault()
    const project = Object.assign({}, this.state.project, {name: e.target.value})
    this.setState({ project })
  }

  handleSubmit(e) {
    e.preventDefault()
    const project = {
      name: '',
      project_type: this.props.projectType,
      admin_id: this.props.currentUser.id
    }
    this.props.postProject(this.state.project).
      then(() => {
        this.setState({ submittedProject: true })
        this.setState({ project })
        if (this.dropdownRef.current) this.dropdownRef.current.hide()
      }).
      catch(res => this.handleErrors(res.responseJSON.errors))
  }

  handleCancel(e) {
    e.preventDefault()
    const project = {
      name: '',
      project_type: this.props.projectType,
      admin_id: this.props.currentUser.id
    }
    if (this.dropdownRef.current) this.dropdownRef.current.hide()
    this.setState({ project })
  }

  handleErrors(err) {
    this.setState({ hasErrors: true })
  }

  render(){
    if(this.state.loading){
      if(this.props.projectType === 'company'){
        return (<Loading />)
      } else {
        return (<div></div>)
      }
    } else {
      return (
        <section className='project-section'>
          {
            this.newProjectButton()
          }
          <h2 className='project-divider'>{this.dividerText()}
          </h2>

          <ul className='card-holder'>
            { this.companyLogo() }
            {
              this.props.projects.map(project => {
                return (<ProjectCard project={project} key={project.id}/>)
              })
            }
            { this.userLinks() }
          </ul>
        </section>
      )
    }
  }
}

export default ProjectSection
