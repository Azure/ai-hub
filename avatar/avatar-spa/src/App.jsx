import MenuBar from './components/MenuBar.jsx'
import Avatar from './components/Avatar.tsx'
import Footer from './components/Footer.jsx'

import './index.css'

function App() {

  return (
    <div>
      <div className="flex-col h-full bg-blue-50 min-h-screen">
        <MenuBar />
        <div className="flex-grow mx-auto pt-4 pb-8 w-[42rem]">
          <Avatar />
        </div>
      </div>
      <Footer />
    </div>
  )
}

export default App